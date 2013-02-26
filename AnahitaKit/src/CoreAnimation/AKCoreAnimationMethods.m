//
//  AKCoreAnimationMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#ifdef QUARTZCORE_H

#import <QuartzCore/QuartzCore.h>

CAGradientLayer *AKAddGradientToView(UIView *view, UIColor *color1,UIColor *color2)
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame  = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)color1.CGColor,(id)color1.CGColor,nil];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [view.layer insertSublayer:gradient atIndex:0];
    view.layer.masksToBounds = YES;
    return gradient;
}

#endif