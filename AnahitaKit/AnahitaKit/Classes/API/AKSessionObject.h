//
//  AKSessionObject.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-13.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKSessionObject;

/**
 @typedef AKSessionAuthenticationError
 
 @abstract
 Error representing what goes wrong with the authentication
 */
typedef enum AKSessionAuthenticationError {
    
    kAKSessionUnAuthorizedError  = 401,
    kAKSessionPersonIsBlockError = 404,
    kAKSessionUnkown = 500
    
} AKSessionAuthenticationError;

/**
 @protocol AKSessionObjectDelegate
 
 @abstract 
 Calls the delegate if a session has been authorized or not
 
 */
@protocol AKSessionObjectDelegate <NSObject>

/**
 @method
 
 @abstract
 called if the authentication succesful
 */
- (void)sessionObject:(AKSessionObject*)sessionObject didAuthenticatePerson:(AKPersonObject*)person;

/**
 @method
 
 @abstract
 called if the authentication failed
 */
- (void)sessionObject:(AKSessionObject*)sessionObject didFailAuthenticationWithError:(AKSessionAuthenticationError)error;
@end

/**
 @class AKSessionObject
 
 @abstract
 Represent a session object
 */
@interface AKSessionObject : AKEntityObject

/**
 @method
 
 @abstract
 Set the current session viewer
 
 */
+ (void)setViewer:(AKPersonObject*)person;

/**
 @method
 
 @abstract
 Return the session viewer
 */
+ (id)viewer;

///-----------------------------------------------------------------------------
/// @name Creating a session
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Creates a session using username/password
 */
+ (id)sessionWithUsername:(NSString*)username password:(NSString*)password;

/**
 @method
 
 @abstract
 Creates a session using oauth  token,secret and service
 */
+ (id)sessionWithOAuthToken:(NSString*)token OAuthSecret:(NSString*)secret OAuthService:(NSString*)service;

/**
 @method
 
 @abstract
 Sets a session oauth token,secret, service. Once set it will try to authenticate the user using 
 oauth criiteria
 */
- (void)setOAuthToken:(NSString*)token OAuthSecret:(NSString*)secret OAuthService:(NSString*)service;

/**
 @method
 
 @abstract
 Login and calls the delegate
 */
- (void)login;

/**
 @method
 
 @abstract
 Set the username password for a session 
 */
- (void)setUsername:(NSString*)username password:(NSString*)password;

/** @abstract session delegate */
@property(nonatomic,weak) id<AKSessionObjectDelegate> delegate;


/** 
 @property

 @abstract
 The viewer object. The logged in person
 */
@property(nonatomic,readonly) AKPersonObject *viewer;

/** @abstract Return if a session has been authenticated. By default its false */
@property(nonatomic,readonly) BOOL isAuthenticated;

@end