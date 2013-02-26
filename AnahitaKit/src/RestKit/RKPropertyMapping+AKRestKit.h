//
//  RKAttributeMapping+CoreEntity.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-16.
//
//

#import "RKAttributeMapping.h"

/** @typedef */
typedef id (^RKPropertyTransformerBlock)(id value, Class destinationType);

/**
 @category

 @abstract
*/
@interface RKAttributeMapping (AKRestKit)

/**
 @method
 
 @abstract
 
*/
+ (instancetype)attributeMappingForKey:(NSString *)key
        usingTransformerBlock:(RKPropertyTransformerBlock)block;
/**
 @method
 
 @abstract
 
*/
+ (instancetype)attributeMappingFromKeyPath:(NSString *)sourceKeyPath
        toKeyPath:(NSString *)destinationKeyPath usingTransformerBlock:(RKPropertyTransformerBlock)block;


/** @abstract */
@property (nonatomic, copy, readonly) RKPropertyTransformerBlock transformerBlock;

@end
