//
//  AKAuthentication.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectManager;

/**
 Authentication notification sent out
 */
extern NSString *const AKAuthenticationDidSucceedNotification;
extern NSString *const AKAuthenticationDidFailNotification;

/**
 Possible authentication error. The enum value matches the HTTP status code
 */
typedef enum AKAuthenticationError {
    /**
     Invalid credentials
     */
    AKAuthenticationInvalidCredentialError = 401,
    /**
     The credentials are correct but the server has blocked the user from accessing 
     the service
     */
    AKAuthenticationUserBlockedError = 403,
    /**
     Some unkown server problem has occured. Try again later
     */
    AKAuthenticationUnkownError       = 500
} AKAuthenticationError;

/**
 Session credentials. A session uses a credential to authenticate a an anahita user
 **/
@interface AKAuthenticationCredential : NSObject

///-----------------------------------------------------------------------------
/// @name Creating new credential
///-----------------------------------------------------------------------------

/**
 Class method to create a new authentication credential
 */
+ (id)credentialWithUsername:(NSString*)username password:(NSString*)password;

/**
 Instance method to create a new authentication credential
 */
- (id)initWithUsername:(NSString*)username password:(NSString*)password;

///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

//username or email
@property (nonatomic,readonly) NSString *username;
//plain text password
@property (nonatomic,readonly) NSString *password;

@end

@class AKAuthentication;

/**
 AKAuthenticationDelegate delegate communicates the authentication result with a delegate object
 */
@protocol AKAuthenticationDelegate <NSObject>

/**
 This delegate method is called if an authentication is succesfull.
 
 @param authentication The authentication object
 */
- (void)authenticationCredentialDidPass:(AKAuthenticationCredential*)credential;

/**
 This delegate method is called if an authentication has failed.
 
 @param authentication The authentication object
 @param error The authentication error code
 */
- (void)authenticationCredential:(AKAuthenticationCredential*)credential DidFailWithError:(AKAuthenticationError)error;

@end

/**
  AKAuthentication authenticate a credential and if a delegate is set it will return the result of 
  the authentication
 */
@interface AKAuthentication : NSObject

///-----------------------------------------------------------------------------
/// @name Creating an authentication
///-----------------------------------------------------------------------------

- (id)initWithObjectManager:(RKObjectManager*)objectManager;

///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 The credential to be authenticated
 */
@property (readonly,nonatomic) RKObjectManager *objectManager;

/**
 The authentication credential
 */
@property (nonatomic,strong) id<AKAuthenticationDelegate> delegate;

///-----------------------------------------------------------------------------
/// @name Authenticating
///-----------------------------------------------------------------------------

- (void)authenticateCredential:(AKAuthenticationCredential*)credential;

@end
