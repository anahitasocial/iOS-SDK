//
//  AKSession.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "AKAnahitaAPI.h"

NSString *const kAKSessionDidLogin = @"kAKSessionDidLogin";
NSString *const kAKSessionDidFailLogin = @"kAKSessionDidFailLogin";
NSString *const kAKSessionDidLogout = @"kAKSessionDidLogout";
NSString *const kAKSessionViewerNotificationKey = @"kAKSessionViewerNotificationKey";

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
       sharedSession = [AKSession new];
    });
    return sharedSession;
}

- (id)initWithCredential:(id<AKSessionCredential>)credential
{
    if ( self = [super init] ) {
        self.credential = credential;
    }    
    return self;
}

- (void)login:(void(^)(AKPerson *viewer))success failure:(void(^)(NSError *error))failure
{
    id<AKSessionCredential> credential = self.credential;
    AKPerson *viewer = [AKPerson new];
    void (^httpSuccess)(RKObjectRequestOperation*, RKMappingResult *)  = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NIDINFO(@"Welcome %@", viewer.name);
        self.viewer = viewer;        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAKSessionDidLogin object:self userInfo:@{kAKSessionViewerNotificationKey:self.viewer}];
        if ( success ) success(viewer);
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKSessionDidLogout
        object:self userInfo:@{kAKSessionViewerNotificationKey:viewer}];
}

@end