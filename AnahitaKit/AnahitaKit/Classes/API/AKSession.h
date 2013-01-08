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
@class AKAuthentication;
@class AKPerson;

/*
 Posted when a session is ready to be used
 */
extern NSString *const AKSessionReadyNotification;
/**
 Posted when a session encounters a problem during start 
 */
extern NSString *const AKSessionErrorNotification;

/**
  Session object provides an authenticated session with an anahita server
 **/
@interface AKSession : NSObject

///-----------------------------------------------------------------------------
/// @name Session Initialization
///-----------------------------------------------------------------------------

/**
 Creates a new session for a site base URL
 
 @param URL An anahita site url
 @return A non-authenticated session
 */
+ (id)sessionWithBaseURL:(NSURL*)URL;

///-----------------------------------------------------------------------------
/// @name Session Authentication
///-----------------------------------------------------------------------------

/**
 Boolean value that determines if the session has been authenticated or not
 */
@property (nonatomic,readonly) BOOL authenticated;

/**
 Session authentication object. Use this object to authentication a {@link AKAuthenticationCredential}
 */
@property (nonatomic,readonly) AKAuthentication* authentication;


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
 Starts a new session 

 @discussion
 When a session starts it communicates with the server to get the server information. Current logged in
 user (viewer). Once the session is ready to be used, {@link AKSessionReadyNotification} is posted. if there's an error
 then {@link AKSessionErrorNotification} is dispatched
 */
- (void)start;

///-----------------------------------------------------------------------------
/// @name Getting current logged in user (Viewer)
///-----------------------------------------------------------------------------

/**
 Return the current viewer object (logged in user)
 */
@property (nonatomic,readonly) AKPerson *viewer;

@end

