//
//  AKOAuthToken.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKOAuthToken
 
 @abstract
 An authentication token from an OAuth service
 */
@interface AKOAuthToken : NSObject

/**
 @method
 
 @abstract
 Creates an authentication token from a key and secret
 
 @param key Token key
 @param secret Token secret key. This can be null or empty
 
 */
- (id)initWithKey:(NSString*)key secret:(NSString*)secret;

/** @abstract Token key */
@property(nonatomic,readonly) NSString *key;

/** @abstract Token secret */
@property(nonatomic,readonly) NSString *secret;

@end