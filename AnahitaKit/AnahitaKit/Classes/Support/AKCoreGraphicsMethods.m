//
//  AKCoreGraphicsMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKCoreGraphicsMethods.h"


NSArray *CGRectDivide2(CGRect rect, NSArray* amounts, CGRectEdge edge)
{
    NSMutableArray *result = [NSMutableArray array];
    
    __block CGRect remainder = rect;
    
    [amounts enumerateObjectsUsingBlock:^(NSNumber *amount, NSUInteger idx, BOOL *stop) {
        CGRect slice;
        CGRectDivide(remainder, &slice, &remainder, amount.floatValue, edge);
        [result addObject:[NSValue valueWithCGRect:slice]];
    }];
    
    [result addObject:[NSValue valueWithCGRect:remainder]];
    
    return result;
}