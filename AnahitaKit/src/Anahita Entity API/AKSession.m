//
//  AKAPISession.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "RestKit.h"

/**
 Session notifications
 */
NSString *const AKSessionIsAuthenticatedNotification        = @"AKSessionIsAuthenticatedNotification";
NSString *const AKSessionRequiresAuthenticationNotification = @"AKSessionRequiresAuthenticationNotification";

/**
 Private session methods
 */
@interface AKSession(Private)

/**
 Called after a succesful authentication
 */
- (void)authenticationDidSucceed;

@end

@implementation AKSession
{    
    //private object manager class
     RKObjectManager *_objectManager;
}

//shared session
+ (id)sharedSession
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithObjectManager:[RKObjectManager sharedManager]];
    });
    return sharedInstance;
}

- (id)initWithObjectManager:(RKObjectManager*)objectManager
{
    if ( self = [super init] )
    {
        //initialize the object manager
        _objectManager = objectManager;
        _authenticated = NO;
    }
    
    return self;
}

#pragma mark Starting session
#import <objc/objc.h>
#import <objc/runtime.h>

- (void)checkSessionIsAuthenticated
{
    __block id<AKSessionDelegate> delegate = self.delegate;
    
    [[AKPersonObject sharedRepository] loadWithQueryDictionary:[NSDictionary dictionary] loader:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            if ( !response.isOK ) {
                if ( delegate != NULL ) {
                    [delegate sessionRequiresAuthentication:self];
                }
                //session is okay then lets dispatch the notification
                [[NSNotificationCenter defaultCenter] postNotificationName:AKSessionRequiresAuthenticationNotification object:self];
            }
        };        
        //on load object if the response is ok and
        //person has been materialzed. This block is run in the main block
        loader.onDidLoadObject = ^(AKPersonObject *person) {
            if ( loader.response.isOK && person != nil ) {
                if ( delegate != NULL ) {
                    [delegate session:self isAuthenticatedWithPerson:person];
                }
                _viewer = person;
                _authenticated = YES;
                //session is okay then lets dispatch the notification
                [[NSNotificationCenter defaultCenter] postNotificationName:AKSessionIsAuthenticatedNotification object:self];
            }
        };
    }];
}

@end

