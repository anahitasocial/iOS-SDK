//
//  AKObjectAvatar.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

typedef enum {
    AKObjectImageSquare = 1,
    AKObjectImageMedium = 2,    
    AKObjectImageLarge = 4    
} AKObjectImageSize;

@interface AKImageURLs : NSObject
{

}

- (id)initWithMappableValue:(id)mappableValue;

- (NSURL*)imageURLWithImageSize:(AKObjectImageSize)imageSize;

//protected methods

@end
