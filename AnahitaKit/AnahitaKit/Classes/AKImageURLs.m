//
//  AKObjectAvatar.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKImageURLs.h"

@implementation AKImageURLs
{
    NSDictionary *_sizes;    
}

- (id)initWithMappableValue:(id)mappableValue;
{
    if ( self = [super init] )
    {
        if ( [mappableValue isKindOfClass:[NSDictionary class]] )
            _sizes = mappableValue;
        else
            _sizes = [NSDictionary dictionary];
    }
    
    return self;
}

- (NSURL*)imageURLWithImageSize:(AKObjectImageSize)imageSize;
{
    NSString *key = nil;
    
    if ( imageSize & AKObjectImageSquare ) {
        key = @"square";
    } 
    else if ( imageSize & AKObjectImageMedium ) {
        key = @"medium";
    }    
    else if ( imageSize & AKObjectImageLarge ) {
        key = @"large";
    }
    
    NSString *path = [_sizes valueForKey:key];
    
    return [NSURL URLWithString:path];
}

@end
