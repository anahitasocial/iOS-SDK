//
//  AKUIKitMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKUIKitMethods.h"
#import <QuartzCore/QuartzCore.h>

UIColor *AKDarkerUIColor(UIColor* color)
{
    return AKDarkenUIColor(color, 1);
}

UIColor *AKDarkenUIColor(UIColor* color, int amount)
{
    float h, s, b, a;
    for(int i = 0;i<amount;i++)
    {
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        color = [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    }

    return color;
}


UIColor *AKLighterUIColor(UIColor* color)
{
    return AKLightenUIColor(color, 1);
}

UIColor *AKLightenUIColor(UIColor* color, int amount)
{

    float h, s, b, a;
    for(int i = 0;i<amount;i++)
    {
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
        color = [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    }
    return color;
}

UIImage *AKImageFromView(UIView *view)
{    
    UIGraphicsBeginImageContext(view.bounds.size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}