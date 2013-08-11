//
//  AKUIKitMethods.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

//#define AKMainScreenSize [[UIScreen mainScreen] bounds].size

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

typedef NSUInteger AKColorValue;

/**
 @method
 
 @abstract
*/
UIColor *AKColorWithValue(AKColorValue value);

/**
 @method
 
 @abstract
*/
UIColor *AKColorWithValueAlpha(AKColorValue value, CGFloat alpha);

/**
 @method
 
 @abstract
*/
UIColor *AKColorDarker(UIColor* color);

/**
 @method
 
 @abstract
*/
UIColor *AKColorDarken(UIColor* color, NSUInteger amount);

/**
 @method
 
 @abstract
*/
UIColor *AKColorLighter(UIColor* color);

/**
 @method
 
 @abstract
*/
UIColor *AKColorLighten(UIColor* color, NSUInteger amount);


/**
 @method
 
 @abstract
*/
UIImage *AKImageFromView(UIView *view);

/**
 @method
 
 @abstract
*/
void AKAlertViewShow(NSString* title, id message, id delegate);