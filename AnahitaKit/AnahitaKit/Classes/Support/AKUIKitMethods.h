//
//  AKUIKitMethods.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#define AKUIAlertViewShowAlert(title,body) \
    [[[UIAlertView alloc] initWithTitle:title message:body delegate:self \
    cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];


#define AKMainScreenSize [[UIScreen mainScreen] bounds].size

/**
 @method
 
 @abstract
 Return a CGRect whose width is equal to the screen width
*/
static inline CGRect CGRectWithScreenWidth(CGFloat x, CGFloat y, CGFloat height) {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin = CGPointMake(x,y); rect.size.height = height;
    return rect;
}

/**
 @method
 
 @abstract
 Return a CGRect whose height is equal to the screen height
*/
static inline CGRect CGRectWithScreenHeight(CGFloat x, CGFloat y, CGFloat width) {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin = CGPointMake(x,y); rect.size.width = width;
    return rect;
}

/**
 @method
 
 @abstract
 Different variaion of UIEdgeInsetsMake that sets the bottom/top and left/right pair
 together
*/
static inline UIEdgeInsets UIEdgeInsetsMake2(int topbottom, int leftright) {
    return UIEdgeInsetsMake(topbottom, leftright, topbottom, leftright);
}


/** @abstract */
UIColor *AKDarkerUIColor(UIColor* color);

UIColor *AKDarkenUIColor(UIColor* color, int amount);

/** @abstract */
UIColor *AKLighterUIColor(UIColor* color);

UIColor *AKLightenUIColor(UIColor* color, int amount);