//
//  UIView+NSNotification.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-01.
//
//

#import "AKFoundation.h"
#import "AKUIKit.h"
#import "JRSwizzle.h"
#import "AKFoundationMethods.h"
#import "AKMixin.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>


@interface UIView_ : UIView @end

@interface UIView()

@property(nonatomic,readonly) NSNotificationCenter* notificationCenter;

@end

@implementation UIView(AKObservable)

SYNTHESIZE_PROPERTY_STRONG(NSNotificationCenter*, _setNotificationCenter, _notificationCenter);

- (NSNotificationCenter*)notificationCenter
{
    if ( ![self _notificationCenter] ) {
        [self _setNotificationCenter:[[NSNotificationCenter alloc] init]];
    }
    return [self _notificationCenter];
}

- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName
{
    [self.notificationCenter addObserver:notificationObserver selector:notificationSelector name:notificationName object:self];
}

- (id)addObserverForName:(NSString *)name queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *))block
{
    return [self.notificationCenter addObserverForName:name object:self queue:queue usingBlock:block];
}

- (id)addObserverForName:(NSString *)name usingBlock:(void (^)(NSNotification *))block
{
    return [self addObserverForName:name queue:nil usingBlock:block];
}

- (void)removeObserver:(id)notificationObserver
{
    [self.notificationCenter removeObserver:notificationObserver];
}

- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName
{
    [self.notificationCenter removeObserver:notificationObserver name:notificationName object:self];
}

- (void)postNotificationName:(NSString *)aName
{
    if ( [self _notificationCenter] ) {
        [self.notificationCenter postNotificationName:aName object:self];
    }
}

- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo
{
    if ( [self _notificationCenter] ) {
        [self.notificationCenter postNotificationName:aName object:self userInfo:aUserInfo];
    }
}

@end

#pragma mark -


NSString *const kAKViewDidInitNotification = @"kAKViewDidInitNotification";
NSString *const kAKViewWillDrawRectNotification = @"kAKViewWillDrawRectNotification";
NSString *const kAKViewDidDrawRectNotification = @"kAKViewDidDrawRectNotification";
NSString *const kAKViewWillLayoutSubViewsNotification = @"kAKViewWillLayoutSubViewsNotification";
NSString *const kAKViewDidLayoutSubViewsNotification = @"kAKViewDidLayoutSubViewsNotification";

NSString *const kAKViewWillRemoveSubViewNotification = @"kAKViewWillRemoveSubViewNotification";
NSString *const kAKViewDidAddSubViewNotification = @"kAKViewDidAddSubViewNotification";
NSString *const kAKViewWillMoveToSuperViewNotification = @"kAKViewWillMoveToSuperViewNotification";
NSString *const kAKViewDidMoveToSuperViewNotification = @"kAKViewDidMoveToSuperViewNotification";


@implementation NSNotification(AKViewHookNotification)

- (UIView*)view {
    return [self.userInfo valueForKey:@"view"];
}

- (CGRect)drawRect {
   return [[self.userInfo valueForKey:@"drawRect"] CGRectValue];
}

@end

#pragma mark -
#pragma mark AKViewNotificationBehavior

static inline void AKFixCallToSuper(Class class, SEL oldMethod, SEL newMethod, Class stopClass)
{
    while (!class_conformsToProtocol(class, @protocol(AKViewHookBehavior))) {
        class = class_getSuperclass(class);
    }
    
    do {
        class = class_getSuperclass(class);
        
        if ( class_conformsToProtocol(class, @protocol(AKViewHookBehavior)) ) {
            [class jr_swizzleMethod:oldMethod withMethod:newMethod error:nil];
        }  
    } while (class && class != stopClass && [class isSubclassOfClass:stopClass]);
    
}

#define __SUPER__(call) \
    SEL _new_cmd = NSSelectorFromString([@"UIView_ViewHook_" stringByAppendingString:NSStringFromSelector(_cmd)]);\
    AKFixCallToSuper([self class],_cmd,_new_cmd,[UIView class]); \
    [self call]; \
    AKFixCallToSuper([self class],_cmd,_new_cmd,[UIView class]); \
    
@interface AKViewHookBehavior : UIView <AKMixin> @end

@implementation AKViewHookBehavior

+ (BOOL)mixinShouldMixWithClass:(Class)class
{
    return [class isSubclassOfClass:[UIView class]];
}

+ (void)exchangeMethod:(SEL)altSelector withClass:(Class)target selector:(SEL)originalSelector
{
    if ( !class_selectorInMethodList(target, originalSelector) ) {
        class_copyMethod(self, originalSelector, target, originalSelector);
    }
    
    if ( class_selectorInMethodList(target, originalSelector) )
    {
        BOOL added = class_copyMethod(self, altSelector, target, altSelector);
        Method origMethod = class_getInstanceMethod(target, originalSelector);
        Method altMethod  = class_getInstanceMethod(target, altSelector);
        method_exchangeImplementations(origMethod, altMethod);
    }
}

+ (void)swizzleViewClassMethods:(Class)class
{
    if ( [class isSubclassOfClass:[UITableView class]])
    {
        [self exchangeMethod:@selector(UIView_ViewHook_initWithFrame:style:) withClass:class selector:@selector(initWithFrame:style:)];
    }    
    else if ( [class isSubclassOfClass:[UITableViewCell class]])
    {
        [self exchangeMethod:@selector(UIView_ViewHook_initWithStyle:reuseIdentifier:) withClass:class selector:@selector(initWithStyle:reuseIdentifier:)];
    }
    else
    {
        [self exchangeMethod:@selector(UIView_ViewHook_initWithFrame:) withClass:class selector:@selector(initWithFrame:)];
    }
    
    if ( class != [UIView class] )
    {
        [self exchangeMethod:@selector(UIView_ViewHook_layoutSubviews) withClass:class selector:@selector(layoutSubviews)];
        [self exchangeMethod:@selector(UIView_ViewHook_drawRect:) withClass:class selector:@selector(drawRect:)];    

        [self exchangeMethod:@selector(UIView_ViewHook_didAddSubView:) withClass:class selector:@selector(didAddSubview:)];
        [self exchangeMethod:@selector(UIView_ViewHook_willRemoveSubview:) withClass:class selector:@selector(willRemoveSubview:)];
        [self exchangeMethod:@selector(UIView_ViewHook_willMoveToSuperview:) withClass:class selector:@selector(willMoveToSuperview:)];
        [self exchangeMethod:@selector(UIView_ViewHook_didMoveToSuperview) withClass:class selector:@selector(didMoveToSuperview)];
    } else {
        //[self exchangeMethod:@selector(UIView_drawLayer:inContext:) withClass:class selector:@selector(drawLayer:inContext:)];
    }
}

+ (void)mixinDidMixSelectors:(NSMutableArray *)selectors withClass:(Class)class
{    
    [self swizzleViewClassMethods:class];
}

- (id)UIView_ViewHook_initWithFrame:(CGRect)frame
{
    __SUPER__(UIView_ViewHook_initWithFrame:frame);
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;
}

- (void)UIView_ViewHook_layoutSubviews
{
    [self postNotificationName:kAKViewWillLayoutSubViewsNotification];
    
    __SUPER__(UIView_ViewHook_layoutSubviews);
    [self postNotificationName:kAKViewDidLayoutSubViewsNotification];
}

//- (void)UIView_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    [self UIView_drawLayer:layer inContext:ctx];
//    //NSLog(@"%@", class_getImplementingClass([self class], _cmd));
//}

- (id)UIView_ViewHook_initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    AKFixCallToSuper([self class], @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class]);
    [self UIView_ViewHook_initWithFrame:frame style:style];
    AKFixCallToSuper([self class], @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class]);
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;
}

- (id)UIView_ViewHook_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    AKFixCallToSuper([self class], @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class]);
    [self UIView_ViewHook_initWithStyle:style reuseIdentifier:reuseIdentifier];
    AKFixCallToSuper([self class], @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class]);
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;       
}

- (void)UIView_ViewHook_drawRect:(CGRect)rect
{
    NSDictionary *userInfo = @{@"drawRect":[NSValue valueWithCGRect:rect]};
    
    [self postNotificationName:kAKViewWillDrawRectNotification userInfo:userInfo];
    
    __SUPER__(UIView_ViewHook_drawRect:rect);
    
    [self postNotificationName:kAKViewDidDrawRectNotification userInfo:userInfo];
}

- (void)UIView_ViewHook_didAddSubView:(UIView*)subview
{
    __SUPER__(UIView_ViewHook_didAddSubView:subview);
    
    [self postNotificationName:kAKViewDidAddSubViewNotification userInfo:subview ? @{@"view":subview} : nil];
}

- (void)UIView_ViewHook_willRemoveSubview:(UIView*)subview
{
    __SUPER__(UIView_ViewHook_willRemoveSubview:subview);
    [self postNotificationName:kAKViewWillRemoveSubViewNotification userInfo:subview ? @{@"view":subview} : nil];
}

- (void)UIView_ViewHook_willMoveToSuperview:(UIView*)superView
{
    __SUPER__(UIView_ViewHook_willMoveToSuperview:superView);
    [self postNotificationName:kAKViewWillMoveToSuperViewNotification userInfo:superView ? @{@"view":superView} : nil];    
}

- (void)UIView_ViewHook_didMoveToSuperview
{
    __SUPER__(UIView_ViewHook_didMoveToSuperview);
    
    [self postNotificationName:kAKViewDidMoveToSuperViewNotification];
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end

@implementation UIView_ @end

@implementation UIView(AKViewUsingBlocks)

+ (UIView*)viewWithFrame:(CGRect)frame;
{
    return [[UIView_ alloc] initWithFrame:frame];
}

@end

#pragma mark - Overloading existing views


ADD_BEHAVIOR_TO_CLASS(UIView, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UIView_, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UISearchBar, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UITableViewCell, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UITableView, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UIWebView, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UILabel, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UINavigationBar, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UIToolbar, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UISegmentedControl, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UIImageView, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UISlider, AKViewHookBehavior);
//ADD_BEHAVIOR_TO_CLASS(UIScrollView, AKViewHookBehavior);
ADD_BEHAVIOR_TO_CLASS(UIActionSheet, AKViewHookBehavior);


