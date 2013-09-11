//
//  AKSession.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "AKAnahitaAPI.h"
#import "FXKeychain.h"


NSString *const kAKSessionDidLogin = @"kAKSessionDidLogin";
NSString *const kAKSessionDidFailLogin = @"kAKSessionDidFailLogin";
NSString *const kAKSessionDidLogout = @"kAKSessionDidLogout";
NSString *const kAKSessionViewerNotificationKey = @"kAKSessionViewerNotificationKey";

NSString *const kAKSessionKeyChainKey = @"kAKSessionKeyChainKey";

@implementation NSDictionary(AKSessionCredential)

- (NSDictionary*)toParameters
{
    return self;
}

@end

@interface AKSessionBasicAuthCredential()

@property(nonatomic,copy) NSString *username, *password;

@end

@implementation AKSessionBasicAuthCredential

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if ( self = [super init] ) {
        self.password = password;
        self.username = username;
    }    
    return self;
}

- (NSDictionary*)toParameters
{
    return @{@"username":self.username,@"password":self.password};
}

@end

@interface AKSession()

@property(nonatomic,readwrite,strong) id<AKSessionCredential> credential;
@property(nonatomic,readwrite,strong) AKPerson * viewer;

@end

@implementation AKSession

/**
 @method 
 
 @abstract
 Return a singleton session object. Tries to login the user using the
 existing username and pasword
*/
+ (instancetype)sessionWithCredential:(id<AKSessionCredential>)credential
{
    AKSession *session = [self sharedSession];
    session.credential = credential;
    return session;
}

+ (instancetype)sharedSession
{
    static AKSession *sharedSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       sharedSession = [[AKSession alloc] init];
       sharedSession.credential = [[FXKeychain defaultKeychain] objectForKey:kAKSessionKeyChainKey];
    });
    return sharedSession;
}

- (id)init
{
    if ( self = [super init] ) {
        self.viewer = [AKPerson new];
        //observe the password
        [self.viewer addObserver:self forKeyPath:@"password" options:NSKeyValueObservingOptionNew context:nil];
;    }
    return self;
}

- (void)login:(void(^)(AKPerson *viewer))success failure:(void(^)(NSError *error))failure
{
    id<AKSessionCredential> credential = self.credential;
    AKPerson *viewer                   = self.viewer;
    void (^httpSuccess)(RKObjectRequestOperation*, RKMappingResult *)  = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NIDINFO(@"Welcome %@", viewer.name);
        //store the credential in they keychain to be used later
        [[FXKeychain defaultKeychain] setObject:[credential toParameters] forKey:kAKSessionKeyChainKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAKSessionDidLogin object:self userInfo:@{kAKSessionViewerNotificationKey:self.viewer}];
        if ( success ) {
            success(viewer);
        }
    };
    void (^httpFailure)(RKObjectRequestOperation*, NSError *)  = ^(RKObjectRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAKSessionDidFailLogin object:self userInfo:nil];
        if ( failure ) failure(error);
    };
    if ( nil == credential ) {
        [[RKObjectManager sharedManager] getObject:viewer path:@"people/session" parameters:nil
            success:httpSuccess failure:httpFailure];    
    } else {
        [[RKObjectManager sharedManager] postObject:viewer path:@"people/session" parameters:[credential toParameters]
            success:httpSuccess failure:httpFailure];
    }

}

- (void)login
{
    [self login:nil failure:nil];
}

- (void)logout
{
    AKPerson *viewer = self.viewer;
    self.viewer = nil;
    [[FXKeychain defaultKeychain] removeObjectForKey:kAKSessionKeyChainKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKSessionDidLogout
        object:self userInfo:@{kAKSessionViewerNotificationKey:viewer}];
}

#pragma mark - Observing viewer attributes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"password"] )
    {
        NSString *newPassword = [change valueForKey:NSKeyValueChangeNewKey];
        [[FXKeychain defaultKeychain] setObject:
            [[[AKSessionBasicAuthCredential alloc] initWithUsername:self.viewer.username andPassword:newPassword] toParameters]
          forKey:kAKSessionKeyChainKey];
    }
}

@end