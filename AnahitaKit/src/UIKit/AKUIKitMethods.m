//
//  AKUIKitMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKUIKitMethods.h"
#import <QuartzCore/QuartzCore.h>

UIColor *AKColorDarker(UIColor* color)
{
    return AKColorDarken(color, 1);
}

UIColor *AKColorDarken(UIColor* color, NSUInteger amount)
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

UIColor *AKColorWithValue(AKColorValue value)
{
    return AKColorWithValueAlpha(value, 1.0f);
}

UIColor *AKColorWithValueAlpha(AKColorValue value, CGFloat alpha)
{
    return [UIColor colorWithRed:(value >> 16)/255.0f green:((value & 0xff00) >> 8) /255.0f blue:(value & 0xff)/255.0f alpha:alpha];
}

UIColor *AKColorLighter(UIColor* color)
{
    return AKColorLighten(color, 1);
}

UIColor *AKColorLighten(UIColor* color, NSUInteger amount)
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

void AKAlertViewShow(NSString* title, id message,id delegate)
{
    dispatch_async(dispatch_get_main_queue()
    , ^{
        NSArray *messages = [message isKindOfClass:[NSArray class]] ? message : @[message];
        NSString *msg     = [messages componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}