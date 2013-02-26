//
//  Anahita_Support.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "AKUIKitMethods.h"
#import "UIView+ViewHooks.h"
#import "UIView+AKRenderAsImage.h"

#define HEXCOLOR(value) \
    [UIColor colorWithRed:(value >> 16)/255.0f green:((value & 0xff00) >> 8) /255.0f blue:(value & 0xff)/255.0f alpha:1]

#define HEXCOLORA(value, a) \
    [UIColor colorWithRed:(value >> 16)/255.0f green:((value & 0xff00) >> 8) /255.0f blue:(value & 0xff)/255.0f alpha:a]
