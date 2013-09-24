//
//  AKConfiguration.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-20.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class RKObjectManager;
@class AKOAuthConsumer;

/**
 Anahita Kit Global configuration 
 */
@interface AKGlobalConfiguration : NSObject

/**
 Shared instance
 */
+ (AKGlobalConfiguration*)sharedInstance;

/**
 sets the shared instance
 */
+ (void)setSharedInstance:(id)sharedInstance;

///-----------------------------------------------------------------------------
/// Anahtia Site configuration
///-----------------------------------------------------------------------------

/**
 Site URL
 */
@property(nonatomic,assign) NSURL *siteURL;

///-----------------------------------------------------------------------------
/// Anahita Connect Configurations
///-----------------------------------------------------------------------------

/**
 OAuths Consumers
 */
@property(nonatomic,readonly) NSArray* oAuthsConsumers;

/**
 Add a oauth consumer to the configuration
 */
- (void)addOAuthConsumer:(AKOAuthConsumer*)consumer;

/**
 Return a consumer for a service or nil if not found
 */
- (AKOAuthConsumer*)oAuthConsumerForService:(NSString*)service;

///-----------------------------------------------------------------------------
/// Anahtia Object Manager Configurations
///-----------------------------------------------------------------------------

/**
 object manager
 */
@property(nonatomic,readonly) RKObjectManager* objectManager;

@end
