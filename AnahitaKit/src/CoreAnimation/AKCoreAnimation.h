//
//  Anahita_Support.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "NSObject+AKCore.h"
#import "NSArray+AKCore.h"
#import "AKDynamicObject.h"
#import "AKThreadSignal.h"
#import "AKFoundationMethods.h"
#import "AKCoreGraphicsMethods.h"
#import "AKCoreAnimationMethods.h"
#import "AKUIKitMethods.h"
#import "AKInflection.h"
#import "AKMixin.h"
#import "AKArrayProxy.h"
#import "NSString+AKCore.h"


#define HEXCOLOR(value) \
    [UIColor colorWithRed:(value >> 16)/255.0f green:((value & 0xff00) >> 8) /255.0f blue:(value & 0xff)/255.0f alpha:1]