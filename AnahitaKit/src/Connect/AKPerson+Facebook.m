//
//  AKPerson+Facebook.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKPerson+Facebook.h"

@implementation AKPerson (Facebook)

- (void)setToken:(NSString *)token service:(AKConnectServiceType)service
{
    NSString* serviceStr = service ==kAKFacebookServiceType ? @"facebook" : @"twitter";
    
    [self setValuesForKeysWithDictionary:@{
        @"oauth_handler" : serviceStr,
        @"oauth_secret"  : @"7w2t4wfh9R7D6u8NQHehCcXjpJAmozEjwIgQtWC5cc",
        @"oauth_token"   : token
    }];
}

@end
