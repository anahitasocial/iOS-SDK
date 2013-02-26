//
//  AKCoreGraphicsMethods.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 * For filling in gaps in Apple's Foundation framework.
 *
 *
 * Utility methods save time and headache.  
 */

/** 
 @method
 
 @abstract
 set the point x
*/
CGPoint CGPointSetX(CGPoint point, CGFloat x);

/** 
 @method
 
 @abstract
 set the point y
*/
CGPoint CGPointSetY(CGPoint point, CGFloat y);

/** 
 @method
 
 @abstract
*/
CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy);

/** 
 @method
 
 @abstract
 Set rect x coordinate
*/
CGRect CGRectSetX(CGRect rect, CGFloat x);

/** 
 @method
 
 @abstract
 Set rect y coordinate
*/
CGRect CGRectSetY(CGRect rect, CGFloat y);

/** 
 @method
 
 @abstract
 Set rect x y cooridnate
*/
CGRect CGRectSetXY(CGRect rect, CGFloat x, CGFloat y);
/** 
 @method
 
 @abstract
 Set rect origin
*/
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);


/** 
 @method
 
 @abstract
 Set rect width
*/
CGRect CGRectSetWidth(CGRect rect, CGFloat width);

/** 
 @method
 
 @abstract
 Set rect height
*/
CGRect CGRectSetHeight(CGRect rect, CGFloat height);

/** 
 @method
 
 @abstract
 Set rect width and height
*/
CGRect CGRectSetWidthHeight(CGRect rect, CGFloat width, CGFloat height);

/** 
 @method
 
 @abstract
 Set rect size
*/
CGRect CGRectSetSize(CGRect rect, CGSize size);
/** 
 @method
 
 @abstract
 Divides and return the remainder rect
*/
CGRect CGRectGetRemainder(CGRect rect, int amount, CGRectEdge divider);
/** 
 @method
 
 @abstract
 Divides and return the slice rect
*/
CGRect CGRectGetSlice(CGRect rect, int amount, CGRectEdge divider);

/** 
 @method
 
 @abstract
*/
CGPoint CGRectGetCenter(CGRect rect);

/** 
 @method
 
 @abstract
*/
CGRect CGRectSetCenter(CGRect rect, CGPoint center);
/** 
 @method
 
 @abstract
*/
CGRect CGRectSetMidX(CGRect rect, CGFloat x);
/** 
 @method
 
 @abstract
*/
CGRect CGRectSetMidY(CGRect rect, CGFloat y);

/** 
 @method
 
 @abstract
*/
NSArray* CGRectDivide2(CGRect rect, NSArray* amounts, CGRectEdge edge);


/** 
 @method
 
 @abstract
*/
void AKCGDrawInnerShadow(CGContextRef context, CGRect bounds, CGFloat radious, CGColorRef fillColor, CGSize shadowOffset, CGFloat shadowBlur, CGColorRef shadowColor);