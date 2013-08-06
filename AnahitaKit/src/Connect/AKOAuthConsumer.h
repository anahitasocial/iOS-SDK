//
//  AKOAuthConsumer.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-23.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKOAuthConsumer
 
 @abstract
 Abstracts an oauth service information such as name, key and secret 
 */
@interface AKOAuthConsumer : NSObject

/**
 @method
 
 @abstract
 Initializes a consumer from a service name, key and secret
 
 @param service The name of the oauth service. example: facebook, twitter or others
 @param key The Application ID or the consumer key
 @param secret The application secret
 */
- (id)initWithService:(NSString*)service key:(NSString*)key secret:(NSString*)secret;

/**
 @method
 
 @abstract
 Initializes a consumer from a service name, key and secret
 
 @param service The name of the oauth service. example: facebook, twitter or others
 @param key The Application ID or the consumer key
 @param secret The application secret
 */
+ (id)consumerForService:(NSString*)service key:(NSString*)key secret:(NSString*)secret;

/** @abstract Service name */
@property(nonatomic,readonly) NSString* service;

/** @abstract Service App ID or key */
@property(nonatomic,readonly) NSString* key;

/** @abstract Service App secret */
@property(nonatomic,readonly) NSString* secret;

@end

