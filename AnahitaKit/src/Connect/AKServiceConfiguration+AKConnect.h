//
//  AKServiceConfiguration+AKConnect.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKServiceConfiguration.h"

/**
 @class
 
 @abstract
*/
@interface AKOAuthConsumer : NSObject

/**
 @method
 
 @abstract
*/
+ (instancetype)consumerWithKey:(NSString*)key secret:(NSString*)secret;

/** @abstract */
@property(nonatomic,readonly) NSString* key;

/** @abstract */
@property(nonatomic,readonly) NSString* secret;

@end

/**
 @class
 
 @abstract
*/
@interface AKServiceConfiguration (AKConnect)

/** @abstract */
@property(nonatomic,strong) AKOAuthConsumer *facebookConsumer;

/** @abstract */
@property(nonatomic,strong) AKOAuthConsumer *twitterConsumer;

@end
