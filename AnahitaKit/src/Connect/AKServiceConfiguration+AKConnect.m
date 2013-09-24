//
//  AKServiceConfiguration+AKConnect.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKConnect.h"
#import <objc/runtime.h>

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

SYNTHESIZE_PROPERTY_STRONG(AKOAuthConsumer*, _setFacebookConsumer, facebookConsumer);
SYNTHESIZE_PROPERTY_STRONG(AKOAuthConsumer*, _setTwitterConsumer, twitterConsumer);

- (void)setFacebookConsumer:(AKOAuthConsumer *)facebookConsumer
{
    [self _setFacebookConsumer:facebookConsumer];    
}

- (void)setTwitterConsumer:(AKOAuthConsumer *)twitterConsumer
{
    [self _setTwitterConsumer:twitterConsumer];
    
    [SHOmniAuth registerProvidersWith:^(SHOmniAuthProviderBlock provider) {
        provider([SHOmniAuthTwitter description], twitterConsumer.key, twitterConsumer.secret, @"friends,location,scopes",
        @"myprovder://callbackurl");
      }];
}

@end
