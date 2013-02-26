//
//  AKNavigationViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-21.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


typedef enum AKNavigationSelectedItemPresentationStyle {
    AKNavigationPresentSelectedItemAsRootViewController = 0,
    AKNavigationPresentSelectedItemAsModal
} AKNavigationSelectedItemPresentationStyle;

/**
 @class AKNavigationItem
 
 @abstract 
*/
@interface AKNavigationItem : NSObject

- (id)initWithTitle:(NSString*)title rootViewController:(UIViewController*)controller iconImage:(UIImage*)iconImage;

/** @abstract Root controller */
@property(nonatomic,strong) UIViewController* controller;

/** @abstract Root controller */
@property(nonatomic,strong) void(^onSelect)();

/** @abstract Root controller */
@property(nonatomic,assign) AKNavigationSelectedItemPresentationStyle presentationStyle;

/** @abstract navigation title */
@property(nonatomic, copy) NSString* title;

/** @abstract image */
@property(nonatomic, strong) UIImage* iconImage;

/** @abstract image */
@property(nonatomic, strong) NSURL* iconImageURL;

@end

/**
 @class AKNavigationItem
 
 @abstract 
*/
@interface AKSideNavigationViewController : UIViewController

/** @abstract selected navigation item */
@property(nonatomic) NSUInteger selectedIndex;

/** @abstract content controller */
@property(nonatomic,readonly) UIViewController *contentController;

/**
 @method
 
 @abstract
 
*/
- (void)addNavigationItem:(AKNavigationItem*)navigationItem;

@end
