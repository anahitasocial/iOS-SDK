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

/** Set point x */
static inline CGPoint CGPointSetX(CGPoint point, CGFloat x) {
    point.x = x;
    return point;
}

/** Set point y */
static inline CGPoint CGPointSetY(CGPoint point, CGFloat y) {
    point.y = y;
    return point;
}

/** Set rect x */
static inline CGRect CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

/** Set rect y coordinate */
static inline CGRect CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

/** Set rect x y cordinates */
static inline CGRect CGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = x;
    rect.origin.y = y;
    return rect;
}

/** Set rect origin */
static inline CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
    rect.origin = origin;
    return rect;
}

/** Set rect width */
static inline CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

/** Set rect height */
static inline CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

/** Set rect width and height */
static inline CGRect CGRectSetWidthHeight(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

/** Set rect size */
static inline CGRect CGRectSetSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
}

/** Divides and return the remainder rect */
static inline CGRect CGRectGetRemainder(CGRect rect, int amount, CGRectEdge divider) {
    CGRect slice, remainder;
    CGRectDivide(rect,&slice,&remainder,amount,divider);
    return remainder;
}

/** Divides and return the slice rect */
static inline CGRect CGRectGetSlice(CGRect rect, int amount, CGRectEdge divider) {
    CGRect slice, remainder;
    CGRectDivide(rect,&slice,&remainder,amount,divider);
    return slice;
}

/** Return a rect whose height value is incremented by the value of amount */
static inline CGRect CGRectIncrementHeight(CGRect rect, int amount) {
    rect.size.height += amount;
    return rect;
}

/** Return a rect whose height value is decremented by the value of amount */
static inline CGRect CGRectDecrementHeight(CGRect rect, int amount) {
    rect.size.height -= amount;
    return rect;
}

/** Return a rect whose width value is incremented by the value of amount */
static inline CGRect CGRectIncrementWidth(CGRect rect, int amount) {
    rect.size.width += amount;
    return rect;
}

/** Return a rect whose width value is decremented by the value of amount */
static inline CGRect CGRectDecrementWidth(CGRect rect, int amount) {
    rect.size.width -= amount;
    return rect;
}

/** Return a rect whose x value is incremented by the value of amount */
static inline CGRect CGRectIncrementX(CGRect rect, int amount) {
    rect.origin.x += amount;
    return rect;
}

/** Return a rect whose x value is decremented by the value of amount */
static inline CGRect CGRectDecrementX(CGRect rect, int amount) {
    rect.origin.x -= amount;
    return rect;
}

/** Return a rect whose y value is incremented by the value of amount */
static inline CGRect CGRectIncrementY(CGRect rect, int amount) {
    rect.origin.y += amount;
    return rect;
}

/** Return a rect whose y value is decremented by the value of amount */
static inline CGRect CGRectDecrementY(CGRect rect, int amount) {
    rect.origin.y -= amount;
    return rect;
}

NSArray* CGRectDivide2(CGRect rect, NSArray* amounts, CGRectEdge edge);

