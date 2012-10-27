//
//  UIImageView+Loader.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-04-20.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Loader)

- (void)setImageWithURL:(NSURL*)aURL;
- (void)setImageWithURL:(NSURL*)aURL onComplete:(void(^)(UIImageView*))onComplete;

@end
