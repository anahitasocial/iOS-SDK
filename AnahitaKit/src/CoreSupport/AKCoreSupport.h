//
//  Anahita_Support.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#define __weak__(object) \
    __weak __typeof(object)weak##object = object;

#define __strong__(object) \
    __typeof(object)strong##object = object;
    
#import "NimbusCore.h"
#import "AKFoundation.h"
#import "AKUIKit.h"
#import "AKCoreGraphics.h"