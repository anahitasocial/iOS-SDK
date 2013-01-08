//
//  NSArray+AKCore.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@implementation NSArray (AKCore)

- (NSArray*)arrayByMappingObjectsUsingBlock:(id(^)(id obj, NSUInteger idx))block
{
    NSMutableArray *newArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id result = block(obj,idx);
            [newArray addObject:result];
    }];
    return newArray;
}

@end
