//
//  AKSessionObject.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-13.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

static AKPersonObject *_sessionViewer;

@implementation AKSessionObject
{
    NSNumber *_personId;
}

+ (void)setViewer:(AKPersonObject *)person
{
    _sessionViewer = person;
}

+ (id)viewer
{
    return _sessionViewer;
}

+ (id)sessionWithOAuthToken:(NSString *)token OAuthSecret:(NSString *)secret OAuthService:(NSString *)service
{
    return [[self alloc] initWithValues:@{@"oauth_token":token,@"oauth_secret":secret,@"oauth_handler":service}];
}

+ (id)sessionWithUsername:(NSString *)username password:(NSString *)password
{
    return [[self alloc] initWithValues:@{@"username":username,@"password":password}];
}

- (void)delete:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookies];
    [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [storage deleteCookie:obj];
    }];
    
    //when deleting a session lets delete the cookies locally first
    [super delete:onSuccess onFailure:onFailure];
}

- (void)login
{
    return [self saveWithDelegate:nil];
}

/**
 Return router object. By defaul
 */
+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    
    configuration.collectionResourcePath =
            configuration.itemResourcePath = @"/people/session";
}

- (void)setOAuthToken:(NSString *)token OAuthSecret:(NSString *)secret OAuthService:(NSString *)service
{
    if ( token && secret ) {
        [self setValuesForKeysWithDictionary:@{@"oauth_token":token,@"oauth_secret":secret,@"oauth_handler":service}];
    }
}

- (void)setUsername:(NSString*)username password:(NSString*)password
{
    [self setValuesForKeysWithDictionary:@{@"username":username,@"password":password}];
}

//if a sessioin has been
- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout __autoreleasing id *)mappableData
{
    id data = *mappableData;
    if ( [data isKindOfClass:[NSDictionary class]] ) {
        _personId = [data valueForKey:@"personId"];                
    }
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader *)objectLoader
{
    if ( _personId != nil ) {
        _viewer = [AKPersonObject objectWithId:_personId.intValue];
        [_viewer loadWithBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObject = ^(id object) {
                if ( self.delegate ) {
                    [[self class] setViewer:_viewer];
                    id copy = [_viewer copy];
                    [self.delegate sessionObject:self didAuthenticatePerson:copy];
                }
            };
        }];
    } 
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ( response.isError ) {
        NIDPRINT(@"Login Error : %@", response.bodyAsString);
        if ( self.delegate ) {
            [self.delegate sessionObject:self didFailAuthenticationWithError:response.statusCode];
        }
    }  
}

- (BOOL)isAuthenticated
{
    return NULL != _viewer;
}

@end
