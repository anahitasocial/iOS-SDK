//
//  AKEntity.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapper;

@protocol AKMappableEntity

+ (void)mapEntity:(RKObjectMapper*)mapping;

@end

/**
 An entity object is a abstract class
 */
@interface AKEntity : NSObject

@end
