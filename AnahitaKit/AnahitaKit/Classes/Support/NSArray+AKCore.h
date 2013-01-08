//
//  NSArray+AKCore.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @category NSArray (AKCore)

 @abstract
*/
@interface NSArray (AKCore)

- (NSArray*)arrayByMappingObjectsUsingBlock:(id(^)(id obj, NSUInteger idx))block;

@end
