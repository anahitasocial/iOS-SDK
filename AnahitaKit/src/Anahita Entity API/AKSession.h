//
//  AKAPISession.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

//class forwarding
@protocol AKAuthenticationDelegate;
@class AKAuthenticationCredential;
@class RKObjectManager;
@class AKAuthenticator;
@class AKPersonObject;
@class AKSession;
/*
 Posted when a session is ready to be used
 */
extern NSString *const AKSessionIsAuthenticatedNotification;
/**
 Posted when a session encounters a problem during start 
 */
extern NSString *const AKSessionRequiresAuthenticationNotification;

/**
 Delegate methods that are called back for a session lifecycle
 */
@protocol AKSessionDelegate <NSObject>

//called if we need to authenticate the user
- (void)sessionRequiresAuthentication:(AKSession*)session;

//called if the user is already authenticated
- (void)session:(AKSession*)session isAuthenticatedWithPerson:(AKPersonObject*)person;

@end

/**
  Session object provides an authenticated session with an anahita server
 **/
@interface AKSession : NSObject

///-----------------------------------------------------------------------------
/// @name Session Initialization
///-----------------------------------------------------------------------------

/**
 Return the shared session instance
 
 @return The share session instance or null if not instantiated
 
 @discussion
    This method should be called after a session has been instantiated 
 */
+ (AKSession*)sharedSession;

///**
// Creates a new session and new object object manager
// 
// @param URL An anahita site url
// @return A non-authenticated session
// */
//+ (AKSession*)sessionWithBaseURL:(NSURL*)URL;

/**
 Creates a session with an object manager
 
 @param Object manager
 */
- (id)initWithObjectManager:(RKObjectManager*)objectManager;

///-----------------------------------------------------------------------------
/// @name Session Authentication
///-----------------------------------------------------------------------------

/**
 Boolean value that determines if the session has been previously authenticated or not
 */
@property (nonatomic,readonly) BOOL authenticated;

/**
 callback backs for the session lifecycle
 */
@property (nonatomic,weak) id<AKSessionDelegate> delegate;

///-----------------------------------------------------------------------------
/// @name Object Loader
///-----------------------------------------------------------------------------

/**
 Session object manager
 */
@property (nonatomic,readonly) RKObjectManager *objectManager;

///-----------------------------------------------------------------------------
/// @name Starting the session
///-----------------------------------------------------------------------------

/**
 Checks if the session is authenticated. Post AKSessionIsAuthenticatedNotification is authenticated 
 otherwise posts AKSessionRequiresAuthenticationNotification
 
 */
- (void)checkSessionIsAuthenticated;

///-----------------------------------------------------------------------------
/// @name Getting current logged in user (Viewer)
///-----------------------------------------------------------------------------

/**
 Return the current viewer object (logged in user)
 */
@property (nonatomic,strong) AKPersonObject *viewer;

@end

