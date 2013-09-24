//
//  AKTwitterReverseOAuth.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-16.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKTwitterReverseOAuth.h"

#import "GCOAuth.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "RestKit.h"
#import "NSDictionary+RKAdditions.h"

/**
 A lot of GCOAuth methods that we need are hidden so we need to redeclare them here in order to use
 */
@interface GCOAuth ()

@property (nonatomic,readonly) NSDictionary *OAuthParameters;
// properties
@property (nonatomic, copy) NSDictionary *requestParameters;
@property (nonatomic, copy) NSString *HTTPMethod;
@property (nonatomic, copy) NSURL *URL;


// generate properly escaped string for the given parameters
+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters;

// create a request with given oauth values
- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
              tokenSecret:(NSString *)tokenSecret;

// generate signature
- (NSString *)signature;

@end

@implementation GCOAuth(Private)

- (NSDictionary*)OAuthParameters
{
    return OAuthParameters;
}

@end

@interface AKTwitterReverseOAuth (RKRequestDelegate) <RKRequestDelegate>
@end

@implementation AKTwitterReverseOAuth
{
    NSString *_consumerKey;
    NSString *_consumerSecret;
    RKRequest *_request;
}

- (id)initWithConsumer:(AKOAuthConsumer*)consumer
{
    return [self initWithConsumerKey:consumer.key consumerSecret:consumer.secret];
}

- (id)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret
{
    if ( self = [super init] ) {
        _consumerKey      = key;
        _consumerSecret   = secret;
        NSAssert(_consumerKey, @"AKTwitterReverseOAuth : Consumer key is missing");
        NSAssert(_consumerSecret, @"AKTwitterReverseOAuth : Consumer secret is missing");
    }
    return self;
}

- (void)reverseAuthenticate
{
    
    NSURL *requestTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    //we use GCOAuth only for singing purpose but for request we use
    //RKRequest directly
    GCOAuth *oauth = [[GCOAuth alloc] initWithConsumerKey:_consumerKey consumerSecret:_consumerSecret accessToken:nil tokenSecret:nil];
    
    oauth.requestParameters = @{@"x_auth_mode":@"reverse_auth"};
    oauth.URL = requestTokenURL;
    oauth.HTTPMethod = @"POST";
    
    NSMutableDictionary *params = [oauth.requestParameters mutableCopy];
    [params addEntriesFromDictionary:oauth.OAuthParameters];
    [params setValue:[oauth signature] forKey:@"oauth_signature"];
    
    _request = [RKRequest requestWithURL:requestTokenURL];
    _request.params = params;
    _request.method = RKRequestMethodPOST;
    _request.delegate = self;
    
    [_request send];

}

#pragma mark - 
#pragma mark RKRequestDelegate methods

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
    //every from down here is taken directly
    //from twitter. visit twitter revese oauth for more information
    if ( response.isOK )
    {
        NSString *S               = response.bodyAsString;
        NSDictionary *step2Params = [[NSMutableDictionary alloc] init];
        [step2Params setValue:_consumerKey forKey:@"x_reverse_auth_target"];
        [step2Params setValue:S forKey:@"x_reverse_auth_parameters"];
        NSURL *url2 = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
        TWRequest *stepTwoRequest =
        [[TWRequest alloc] initWithURL:url2 parameters:step2Params requestMethod:TWRequestMethodPOST];
        

        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterType   = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        id block = block_fom_selector(@selector(accountStore:accountType:request:requestGranted:error:)
                                      ,accountStore,twitterType,stepTwoRequest,nil);
        
        [accountStore requestAccessToAccountsWithType:twitterType
                                withCompletionHandler:block];
              
    }
}

- (void)accountStore:(ACAccountStore*)store accountType:(ACAccountType*)type request:(TWRequest*)request requestGranted:(BOOL)granted error:(NSError*)error
{
    if (granted) {
        NSArray *accounts = [store accountsWithAccountType:type];
        [request setAccount:[accounts objectAtIndex:0]];
        [request performRequestWithHandler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             NSString *responseStr = [[NSString alloc] initWithData:responseData
                                   encoding:NSUTF8StringEncoding];
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 NSDictionary *params = [responseStr queryParameters];
                 NSString *oauthToken  = [params valueForKey:@"oauth_token"];
                 NSString *oauthSecret = [params valueForKey:@"oauth_token_secret"];                 
                 if ( self.delegate ) {
                     [self.delegate twitterReverseOAuth:self didSucceedWithToken:oauthToken secret:oauthSecret info:params];
                 }
             });
         }];
    }
}

@end
