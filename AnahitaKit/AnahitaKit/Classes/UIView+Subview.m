//
//  UIView+Subview.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

- (UIView*)addSubviewUsingBlock:(UIView* ( ^ )())block
{
    UIView *subview = block();
    [self addSubview:subview];
    return subview;
}

- (UIView *)addSubviewWithTag:(NSInteger)tag usingBlock:(UIView* ( ^ )())block
{
    UIView *subview = [self viewWithTag:tag];
    
    if ( !subview ) 
    {
        subview = [self addSubviewUsingBlock:block];
        subview.tag = tag;
        [self addSubview:subview];
    } 
    
    return subview;
}

@end
