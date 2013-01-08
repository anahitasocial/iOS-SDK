//
//  AKAuthentication.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKAuthentication.h"
#import "RestKit.h"

/**
 Notifications
 */
NSString *const AKAuthenticationDidSucceedNotification = @"AKAuthenticationDidSucceedNotification";
NSString *const AKAuthenticationDidFailNotification = @"AKAuthenticationDidSucceedNotification";

/**
 AKAuthenticationCredential
 */

@implementation AKAuthenticationCredential

+ (id)credentialWithUsername:(NSString*)username password:(NSString*)password
{
    return [[AKAuthenticationCredential alloc] initWithUsername:username password:password];
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password
{
    if ( self = [super init] ) {
        _username  = username;
        _password  = password;
    }
    return self;
}

@end

/**
  Authentication is a loader delegate
 */
@interface AKAuthentication(Private) <RKObjectLoaderDelegate>

@end

/**
 AKAuthentication
 */
@implementation AKAuthentication

- (id)initWithObjectManager:(RKObjectManager*)objectManager;
{
    if ( self = [super init] ) {
        _objectManager = objectManager;
    }
    return self;
}

- (void)authenticateCredential:(AKAuthenticationCredential*)credential
{
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:@"/people/session"];
    loader.delegate = self;
    loader.method   = RKRequestMethodPOST;
    loader.userData = credential;
    //@TODO should either use the loader
    //username/password or use object manager postObject
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@", credential.username,credential.password];
    [loader setHTTPBodyString:body];
    [loader send];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response;
{
    if ( response.isOK ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AKAuthenticationDidSucceedNotification object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:AKAuthenticationDidFailNotification object:self];
    }
    
    if ( self.delegate )
    {
        AKAuthenticationCredential *credential = (AKAuthenticationCredential*)request.userData;
        
        if ( response.isOK )
        {
            [self.delegate authenticationCredentialDidPass:credential];
        } else {
            [self.delegate authenticationCredential:credential DidFailWithError:response.statusCode];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {}

@end
