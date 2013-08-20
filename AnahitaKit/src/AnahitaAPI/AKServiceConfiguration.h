//
//  AKServiceConfiguration.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import <Foundation/Foundation.h>

@interface AKServiceConfiguration : NSObject

/**
 @method
 
 @abstract
*/
+ (instancetype)sharedConiguration;

/** @abstract */
@property(nonatomic,strong) NSURL *serviceURL;

@end
