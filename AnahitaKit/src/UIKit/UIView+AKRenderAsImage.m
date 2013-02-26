//
//  UIView+AKRenderAsImage.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-01.
//
//

#import "AKUIKit.h"

@implementation UIView (AKRenderAsImage)

- (UIImage*)renderAsImage {
    return AKImageFromView(self);
}

@end
