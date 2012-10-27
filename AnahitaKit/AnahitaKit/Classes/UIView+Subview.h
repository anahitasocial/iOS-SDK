//
//  UIView+Subview.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Subview)

//Return a subview with tag, if not found then adds
//returned view from the block with as subview
- (UIView*)addSubviewWithTag:(NSInteger)tag usingBlock:(UIView* ( ^ )())block;
- (UIView*)addSubviewUsingBlock:(UIView* ( ^ )())block;

@end
