//
//  AKAuthentication.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

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

@class AKAuthenticator;

/**
 AKAuthenticationDelegate delegate communicates the authentication result with a delegate object
 */
@protocol AKAuthenticatorDelegate <NSObject>

@required

/**
 This delegate method is called if an authentication is succesfull.
 
 @param The authenticator object
 @param The credential authenticated
 */
- (void)authenticator:(AKAuthenticator*)authenticator didAuthenticateCredential:(AKAuthenticationCredential*)credential;

@optional

/**
 This delegate method is called if an authentication has failed.
 
 @param The authenticator object
 @param The credential authenticated
 @param error The authentication error
 */
- (void)authenticator:(AKAuthenticator*)authenticator didFailAuthenticatingCredential:(AKAuthenticationCredential*)authenticationCredential
        withError:(AKAuthenticationError)error;

@end


/**
  AKAuthentication authenticate a credential and if a delegate is set it will return the result of 
  the authentication
 */
@interface AKAuthenticator : NSObject

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
@property (nonatomic,weak) id<AKAuthenticatorDelegate> delegate;

///-----------------------------------------------------------------------------
/// @name Authenticating
///-----------------------------------------------------------------------------

- (void)authenticateCredential:(AKAuthenticationCredential*)credential;

@end
