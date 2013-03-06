//
//  UIView+NSNotification.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-01.
//
//

#import "AKMixin.h"


/**
 @protocol 
 
 @abstract
 View Notification behavior adds notificaiton ability to any view
*/
@interface UIView(AKObservable)

/** @abstract */
- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName;

/** @abstract */
- (id)addObserverForName:(NSString *)name queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *))block;

/** @abstract */
- (id)addObserverForName:(NSString *)name usingBlock:(void (^)(NSNotification *))block;

/** @abstract */
- (void)removeObserver:(id)notificationObserver;

/** @abstract */
- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName;

/** @abstract */
- (void)postNotificationName:(NSString *)aName;

/** @abstract */
- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo;

@end

DEFINE_BEHAVIOR(AKViewHookBehavior) @end

typedef void(^AKViewDrawRectBlock)(CGRect rect);
typedef void(^AKViewLayoutSubViewsBlock)();

@interface UIView(AKViewUsingBlocks)

+ (UIView*)viewWithFrame:(CGRect)frame;

@end

/**
 @category NSNotification_UIView
 
 @abstract 
 Adds extra properties to a notification class
*/
@interface NSNotification(AKViewNotification)

/** @abstract */
@property(nonatomic,readonly) UIView *view;

/** @abstract */
@property(nonatomic,readonly) CGRect drawRect;

@end

/**
 View Notifications
*/
extern NSString *const kAKViewDidInitNotification;

extern NSString *const kAKViewWillDrawRectNotification;
extern NSString *const kAKViewDidDrawRectNotification;

extern NSString *const kAKViewWillLayoutSubViewsNotification;
extern NSString *const kAKViewDidLayoutSubViewsNotification;

extern NSString *const kAKViewWillLayoutSubViewsNotification;
extern NSString *const kAKViewDidLayoutSubViewsNotification;

extern NSString *const kAKViewWillRemoveSubViewNotification;
extern NSString *const kAKViewDidAddSubViewNotification;
extern NSString *const kAKViewWillMoveToSuperViewNotification;
extern NSString *const kAKViewDidMoveToSuperViewNotification;