//
//  AKServiceConfiguration+AKConnect.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKConnect.h"
#import "FBSettings.h"
#import <objc/runtime.h>

NSString *const kAKListTwitterAppIDKey = @"TwitterAppID";
NSString *const kAKListTwitterAppSecretKey = @"TwitterAppSecret";

@interface AKOAuthConsumer()

@property(nonatomic,readwrite,strong) NSString* key;
@property(nonatomic,readwrite,strong) NSString* secret;

@end

@implementation AKOAuthConsumer

+ (id)consumerWithKey:(NSString *)key secret:(NSString *)secret
{
    AKOAuthConsumer *consumer = [AKOAuthConsumer new];
    consumer.secret = secret;
    consumer.key    = key;
    return consumer;
}

@end

@implementation AKServiceConfiguration (AKConnect)

SYNTHESIZE_PROPERTY_STRONG(AKOAuthConsumer*, _setFacebookConsumer, _facebookConsumer);
SYNTHESIZE_PROPERTY_STRONG(AKOAuthConsumer*, _setTwitterConsumer, _twitterConsumer);

- (void)setFacebookConsumer:(AKOAuthConsumer *)facebookConsumer
{
    [self _setFacebookConsumer:facebookConsumer];    
}

- (AKOAuthConsumer*)facebookConsumer
{
    if ( [self _facebookConsumer] == nil ) {
        NSString *appId = [FBSettings defaultAppID];
        if ( appId ) {
            self.facebookConsumer = [AKOAuthConsumer consumerWithKey:appId secret:nil];
        }
    }
    return [self _facebookConsumer];
}

- (void)setTwitterConsumer:(AKOAuthConsumer *)twitterConsumer
{
    [self _setTwitterConsumer:twitterConsumer];
    
    [SHOmniAuth registerProvidersWith:^(SHOmniAuthProviderBlock provider) {
        provider([SHOmniAuthTwitter description], twitterConsumer.key, twitterConsumer.secret, @"friends,location,scopes",
        @"myprovder://callbackurl");
      }];
}

- (AKOAuthConsumer*)twitterConsumer
{
    if ( [self _twitterConsumer] == nil ) {
        NSBundle* bundle = [NSBundle mainBundle];
        NSString *key = [bundle objectForInfoDictionaryKey:kAKListTwitterAppIDKey];
        NSString *secret = [bundle objectForInfoDictionaryKey:kAKListTwitterAppSecretKey];
        if ( key && secret ) {
            self.twitterConsumer = [AKOAuthConsumer consumerWithKey:key secret:secret];
        }
    }
    return [self _twitterConsumer];
}

@end
