//
//  AKOAuthSessionCredential.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-14.
//
//

#import "AKConnect.h"

@interface AKOAuthSessionCredential()

@property(nonatomic,readwrite) NSString* token;
@property(nonatomic,readwrite) NSString* secret;
@property(nonatomic,readwrite,assign) AKConnectServiceType serviceType;

@end

@implementation AKOAuthSessionCredential

+ (id)credentialWithToken:(NSString *)token secret:(NSString *)secret serivce:(AKConnectServiceType)service
{
    AKOAuthSessionCredential *credt = [AKOAuthSessionCredential new];
    credt.token  = token;
    credt.secret = secret;
    credt.serviceType = service;
    return credt;
}

- (NSDictionary*)toParameters
{
    NSString* service = self.serviceType == kAKFacebookServiceType ? @"facebook" : @"twitter";
    
    return @{
        @"oauth_handler" : service,
        @"oauth_secret"  : self.secret,
        @"oauth_token"   : self.token
    };
}

@end
