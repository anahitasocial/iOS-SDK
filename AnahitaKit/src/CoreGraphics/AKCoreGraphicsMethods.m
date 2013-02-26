//
//  AKCoreGraphicsMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKCoreGraphicsMethods.h"

CGPoint CGPointSetX(CGPoint point, CGFloat x) {
    point.x = x;
    return point;
}

/** Set point y */
CGPoint CGPointSetY(CGPoint point, CGFloat y) {
    point.y = y;
    return point;
}

CGPoint CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
    point.x += dx;
    point.y += dy;
    return point;
}

/** Set rect x */
CGRect CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

/** Set rect y coordinate */
CGRect CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

/** Set rect x y cordinates */
CGRect CGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = x;
    rect.origin.y = y;
    return rect;
}

/** Set rect origin */
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
    rect.origin = origin;
    return rect;
}


/** Set rect width */
CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

/** Set rect height */
CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

/** Set rect width and height */
CGRect CGRectSetWidthHeight(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

/** Set rect size */
CGRect CGRectSetSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
}

/** Divides and return the remainder rect */
CGRect CGRectGetRemainder(CGRect rect, int amount, CGRectEdge divider) {
    CGRect slice, remainder;
    CGRectDivide(rect,&slice,&remainder,amount,divider);
    return remainder;
}

/** Divides and return the slice rect */
CGRect CGRectGetSlice(CGRect rect, int amount, CGRectEdge divider) {
    CGRect slice, remainder;
    CGRectDivide(rect,&slice,&remainder,amount,divider);
    return slice;
}

CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


/** Set rect origin */
CGRect CGRectSetCenter(CGRect rect, CGPoint center) {    
    rect.origin.x = center.x - rect.size.width/2;
    rect.origin.y = center.y -  rect.size.height/ 2;
    return rect;
}

CGRect CGRectSetMidX(CGRect rect, CGFloat x) {
    rect.origin.x = x - rect.size.width/2;
    return rect;
}

CGRect CGRectSetMidY(CGRect rect, CGFloat y) {
    rect.origin.y = y -  rect.size.height/ 2;
    return rect;
}

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

void AKCGDrawInnerShadow(CGContextRef context, CGRect bounds, CGFloat radious, CGColorRef fillColor, CGSize shadowOffset, CGFloat shadowBlur, CGColorRef shadowColor)
{
    CGContextSaveGState(context);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radious];
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRect:CGRectInset(bounds, -100, -100)];

    if ( !shadowColor ) {
        shadowColor = [UIColor blackColor].CGColor;
    }
    
    if ( fillColor ) {
        //fill the inside
        CGContextSetFillColorWithColor(context, fillColor);
        CGContextAddPath(context, innerPath.CGPath);
        CGContextFillPath(context);
    }

    //all drawing will be done in the inner path
    CGContextAddPath(context, innerPath.CGPath);
    CGContextClip(context);
    
    //merge outer path and inner paht
    [outerPath appendPath:innerPath];
    CGContextAddPath(context, outerPath.CGPath);
    
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlur, shadowColor);
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
}