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
CGPoint AKPointSetX(CGPoint point, CGFloat x);

/** 
 @method
 
 @abstract
 set the point y
*/
CGPoint AKPointSetY(CGPoint point, CGFloat y);

/** 
 @method
 
 @abstract
*/
CGPoint AKPointOffset(CGPoint point, CGFloat dx, CGFloat dy);

/** 
 @method
 
 @abstract
 Set rect x coordinate
*/
CGRect AKRectSetX(CGRect rect, CGFloat x);

/** 
 @method
 
 @abstract
 Set rect y coordinate
*/
CGRect AKRectSetY(CGRect rect, CGFloat y);

/** 
 @method
 
 @abstract
 Set rect x y cooridnate
*/
CGRect AKRectSetXY(CGRect rect, CGFloat x, CGFloat y);
/** 
 @method
 
 @abstract
 Set rect origin
*/
CGRect AKRectSetOrigin(CGRect rect, CGPoint origin);


/** 
 @method
 
 @abstract
 Set rect width
*/
CGRect AKRectSetWidth(CGRect rect, CGFloat width);

/** 
 @method
 
 @abstract
 Set rect height
*/
CGRect AKRectSetHeight(CGRect rect, CGFloat height);

/** 
 @method
 
 @abstract
 Set rect width and height
*/
CGRect AKRectSetWidthHeight(CGRect rect, CGFloat width, CGFloat height);

/** 
 @method
 
 @abstract
 Set rect size
*/
CGRect AKRectSetSize(CGRect rect, CGSize size);
/** 
 @method
 
 @abstract
 Divides and return the remainder rect
*/
CGRect AKRectGetRemainder(CGRect rect, int amount, CGRectEdge divider);
/** 
 @method
 
 @abstract
 Divides and return the slice rect
*/
CGRect AKRectGetSlice(CGRect rect, int amount, CGRectEdge divider);

/** 
 @method
 
 @abstract
*/
CGPoint AKRectGetCenter(CGRect rect);

/** 
 @method
 
 @abstract
*/
CGRect AKRectSetCenter(CGRect rect, CGPoint center);
/** 
 @method
 
 @abstract
*/
CGRect AKRectSetMidX(CGRect rect, CGFloat x);
/** 
 @method
 
 @abstract
*/
CGRect AKRectSetMidY(CGRect rect, CGFloat y);

/** 
 @method
 
 @abstract
*/
NSArray* AKRectDivide2(CGRect rect, NSArray* amounts, CGRectEdge edge);


/** 
 @method
 
 @abstract
*/
void AKDrawInnerShadow(CGContextRef context, CGRect bounds, CGFloat radious, CGColorRef fillColor, CGSize shadowOffset, CGFloat shadowBlur, CGColorRef shadowColor);