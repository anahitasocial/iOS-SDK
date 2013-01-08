//
//  AKTwitterReverseOAuth.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-16.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKTwitterReverseOAuth;

/**
 Communicates the reverse oauth authentication with twitter to the delegate object. All these methods 
 are called on the main thread
 */
@protocol AKTwitterReverseOAuthDelegate <NSObject>

/**
 When a reverse oauth is successful then this method is called passing the token and secret
 
 */
- (void)twitterReverseOAuth:(AKTwitterReverseOAuth*)reverseOAuth didSucceedWithToken:(NSString*)token secret:(NSString*)secret info:(NSDictionary*)info;

/**
 When a reverse oauth fails it calls this mehtod with an error number
 
 */
- (void)twitterReverseOAuth:(AKTwitterReverseOAuth *)reverseOAuth didFailWithError:(int)error;

@end

/**
 Performs a twitter revese oauth and return a access token, secret token of the currently
 linked account with the twitter
 
 */
@interface AKTwitterReverseOAuth : NSObject

///-----------------------------------------------------------------------------
/// @name Creating a reverse oauth 
///-----------------------------------------------------------------------------

- (id)initWithConsumer:(AKOAuthConsumer*)consumer;
- (id)initWithConsumerKey:(NSString*)key consumerSecret:(NSString*)secret;

- (void)reverseAuthenticate;

@property(nonatomic,weak) id<AKTwitterReverseOAuthDelegate> delegate;

@end
