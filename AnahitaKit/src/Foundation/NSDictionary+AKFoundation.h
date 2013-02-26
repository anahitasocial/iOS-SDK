//
//  NSArray+AKCore.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @category NSDictionary (AKFoundation)

 @abstract
*/
@interface NSDictionary (AKFoundation)

/**
 @method
 
 @abstract
*/
- (NSDictionary*)dictionaryByMappingObjectsUsingBlock:(id(^)(id key, id obj))block;

/**
 @method
 
 @abstract
*/
- (NSDictionary*)dictionaryByReducingObjectsUsingBlock:(BOOL(^)(id key, id obj))block;

@end
