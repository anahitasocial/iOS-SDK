//
//  Anahita_Support.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKApplicationStyle.h"
#import "UIView+AKStyler.h"


#define StyleFor(name) \
    - (void)style##name:(UIView*)stylableView

#define UndoStyleFor(name) \
    - (void)undoStyle##name:(UIView*)stylableView

#define StyleForType(name, type) \
    - (void)style##name:(type*)stylableView

#define UndoStyleForType(name, type) \
    - (void)undoStyle##name:(type*)stylableView