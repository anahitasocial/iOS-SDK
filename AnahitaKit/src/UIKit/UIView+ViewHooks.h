//
//  UIView+NSNotification.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-01.
//
//


typedef void(^AKViewDrawRectBlock)(CGRect rect);
typedef void(^AKViewLayoutSubViewsBlock)();

typedef void(^AKViewDidAddSubViewBlock)(UIView* view);
typedef AKViewDidAddSubViewBlock AKViewWillRemoveSubViewBlock;
typedef AKViewDidAddSubViewBlock AKViewWillMoveToSuperViewBlock;
typedef void(^AKViewDidMoveToSuperView)();

#import "AKMixin.h"

/**
 @protocol 
 
 @abstract
 View Notification behavior adds notificaiton ability to any view
*/
@interface UIView(ViewHooks)

/** @abstract */
@property(nonatomic,strong) AKViewLayoutSubViewsBlock beforeLayoutSubViewsBlock;

/** @abstract */
@property(nonatomic,strong) AKViewLayoutSubViewsBlock layoutSubViewsBlock;

/** @abstract */
@property(nonatomic,strong) AKViewLayoutSubViewsBlock afterLayoutSubViewsBlock;

/** @abstract */
@property(nonatomic,strong) AKViewDrawRectBlock beforeDrawRectBlock;

/** @abstract */
@property(nonatomic,strong) AKViewDrawRectBlock drawRectBlock;

/** @abstract */
@property(nonatomic,strong) AKViewDrawRectBlock afterDrawRectBlock;

/** @abstract */
@property(nonatomic,strong) AKViewDidAddSubViewBlock didAddSubViewBlock;

/** @abstract */
@property(nonatomic,strong) AKViewWillRemoveSubViewBlock willRemoveSubViewBlock;

/** @abstract */
@property(nonatomic,strong) AKViewWillMoveToSuperViewBlock willMoveToSuperViewBlock;

/** @abstract */
@property(nonatomic,strong) AKViewDidMoveToSuperView didMoveToSuperViewBlock;

@end

DEFINE_BEHAVIOR(AKViewHookBehavior) @end

@interface UIView(HookableView)

+ (UIView*)viewWithFrame:(CGRect)frame;

@end

/**
 @category NSNotification_UIView
 
 @abstract 
 Adds extra properties to a notification class
*/
@interface NSNotification(AKViewHookNotification)

/** @abstract */
@property(nonatomic,readonly) UIView *view;

@end

/**
 View Notifications
*/
extern NSString *const kAKViewDidInitNotification;
