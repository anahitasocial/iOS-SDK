//
//  AKAPISession.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKSession.h"
#import "AKAuthentication.h"
#import "AKPerson.h"
#import "RestKit.h"

/**
 Session notifications
 */
NSString *const AKSessionReadyNotification = @"AKSessionReadyNotification";
NSString *const AKSessionErrorNotification = @"AKSessionErrorNotification";

/**
 Private subclass of RKObjectManager
 */
@interface AKSessionObjectManager : RKObjectManager

@end

/**
 Private session methods
 */
@interface AKSession(Private)

/**
 Initializes a session with a baseURL
 
 @param URL Site base URL
 @return A session
 */
- (id)initWithBaseURL:(NSURL*)URL;

/**
 Called after a succesful authentication
 */
- (void)authenticationDidSucceed;

@end

@implementation AKSession
{
    //internal authentication class
     AKAuthentication *_authentication;
    
    //private object manager class
     AKSessionObjectManager *_objectManager;
}

//creates a new session
+ (id)sessionWithBaseURL:(NSURL *)URL
{
    AKSession *session = [[AKSession alloc] initWithBaseURL:URL];
    return session;
}

//initilize a session with credential
- (id)initWithBaseURL:(NSURL *)URL
{
    if ( self = [super init] )
    {        
        //initialize the object manager
        _objectManager = [[AKSessionObjectManager alloc] initWithBaseURL:[RKURL URLWithBaseURL:URL]];
    }
    
    return self;
}

#pragma mark Starting session

- (void)start
{
    //get the person;
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[AKPerson class]];
    [mapping mapAttributes:@"id",@"name", nil];
    
    [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:@"/people/person"];
    
    __block RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:@"/people/person"];
    
    loader.onDidLoadResponse = ^(RKResponse *response) {
        if ( !response.isOK ) {
            //session is okay then lets dispatch the notification
            [[NSNotificationCenter defaultCenter] postNotificationName:AKSessionErrorNotification object:self];
        }
    };
    
    //on load object if the response is ok and
    //person has been materialzed. This block is run in the main block
    loader.onDidLoadObject = ^(AKPerson *person) {
        if ( loader.response.isOK && person != nil ) {
            _viewer = person;
            //session is okay then lets dispatch the notification
            [[NSNotificationCenter defaultCenter] postNotificationName:AKSessionReadyNotification object:self];
        }
    };

    [loader send];
}

#pragma mark Authentication

- (AKAuthentication*)authentication
{
    if ( !_authentication )
    {
        _authentication = [[AKAuthentication alloc] initWithObjectManager:self.objectManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationDidSucceed) name:AKAuthenticationDidSucceedNotification object:_authentication];
    }
    return _authentication;
}

- (void)authenticationDidSucceed
{
    _authenticated = YES;
}

@end

/**
 Session object manager
 */
@implementation AKSessionObjectManager


@end
