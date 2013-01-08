//
//  AKObjectMappings.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RKObjectMapping.h"

/**
 @class AKObjectMappings
 
 @abstract 
 Encapuslate both serializer and deserializer for an object
 
 */
@interface AKObjectMapping : RKObjectMapping

/**
 @method

 @abstract
 maps a relationship to another object
*/
- (void)mapRelationship:(NSString*)relationship toObjectClass:(Class)class;

@end

