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

static inline void AKSwizzleMethodBackForParentClass(id object,
        SEL oldMethod, SEL newMethod, Class stopClass, void (^callback)()

)
{
    if ( callback )
    {
        Class class = class_getImplementingClass([object class], newMethod);
        
        AKSwizzleMethodBackForParentClass(class_getSuperclass(class), oldMethod, newMethod, stopClass, nil);
        callback();
        AKSwizzleMethodBackForParentClass(class_getSuperclass(class), oldMethod, newMethod, stopClass, nil);
    }
    else
    {
        if ( class_selectorInMethodList(object, newMethod) )
        {
            [object jr_swizzleMethod:oldMethod withMethod:newMethod error:nil];
        }
        if ( object != stopClass && [object isSubclassOfClass:stopClass]) {
            AKSwizzleMethodBackForParentClass([object superclass], oldMethod, newMethod, stopClass, nil);
        } 
    }
}


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
        [self exchangeMethod:@selector(UITableView_ViewHook_initWithFrame:style:) withClass:class selector:@selector(initWithFrame:style:)];
    }    
    else if ( [class isSubclassOfClass:[UITableViewCell class]])
    {
        [self exchangeMethod:@selector(UITableViewCell_ViewHook_initWithStyle:reuseIdentifier:) withClass:class selector:@selector(initWithStyle:reuseIdentifier:)];
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
    }
}

+ (void)mixinDidMixSelectors:(NSMutableArray *)selectors withClass:(Class)class
{    
    [self swizzleViewClassMethods:class];
}

- (id)UIView_ViewHook_initWithFrame:(CGRect)frame
{
    AKSwizzleMethodBackForParentClass(self, @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class],^(){
        [self UIView_ViewHook_initWithFrame:frame];
    });
    
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;
}

- (void)UIView_ViewHook_layoutSubviews
{
    [self postNotificationName:kAKViewWillLayoutSubViewsNotification];
    
    AKSwizzleMethodBackForParentClass(self, @selector(layoutSubviews), @selector(UIView_ViewHook_layoutSubviews), [UIView class], ^{

        [self UIView_ViewHook_layoutSubviews];
    });
    
    [self postNotificationName:kAKViewDidLayoutSubViewsNotification];
}

- (id)UITableView_ViewHook_initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    AKSwizzleMethodBackForParentClass(self, @selector(initWithFrame:), @selector(UIView_ViewHook_initWithFrame:), [UIView class],^(){
        [self UITableView_ViewHook_initWithFrame:frame style:style];
    });
    
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;
}

- (id)UITableViewCell_ViewHook_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    AKSwizzleMethodBackForParentClass(self, @selector(initWithFrame:),
        @selector(UIView_ViewHook_initWithFrame:), [UIView class],^(){
        [self UITableViewCell_ViewHook_initWithStyle:style reuseIdentifier:reuseIdentifier];
    });
    
    NSDictionary *userInfo = @{@"view":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKViewDidInitNotification object:(id)[self class] userInfo:userInfo];    
    return self;       
}

- (void)UIView_ViewHook_drawRect:(CGRect)rect
{
    NSDictionary *userInfo = @{@"drawRect":[NSValue valueWithCGRect:rect]};
    
    [self postNotificationName:kAKViewWillDrawRectNotification userInfo:userInfo];
    
    AKSwizzleMethodBackForParentClass(self, @selector(drawRect:), @selector(UIView_ViewHook_drawRect:), [UIView class], ^{
        
        [self UIView_ViewHook_drawRect:rect];
    });
    
    [self postNotificationName:kAKViewDidDrawRectNotification userInfo:userInfo];
}

- (void)UIView_ViewHook_didAddSubView:(UIView*)subview
{
    AKSwizzleMethodBackForParentClass(self, @selector(didAddSubview:), @selector(UIView_ViewHook_didAddSubView:), [UIView class], ^{
        [self UIView_ViewHook_didAddSubView:subview];
        [self postNotificationName:kAKViewDidAddSubViewNotification userInfo:subview ? @{@"view":subview} : nil];
    });
}

- (void)UIView_ViewHook_willRemoveSubview:(UIView*)subview
{
    AKSwizzleMethodBackForParentClass(self, @selector(willRemoveSubview:), @selector(UIView_ViewHook_willRemoveSubview:), [UIView class], ^{
        [self UIView_ViewHook_willRemoveSubview:subview];
        [self postNotificationName:kAKViewWillRemoveSubViewNotification userInfo:subview ? @{@"view":subview} : nil];
    });
}

- (void)UIView_ViewHook_willMoveToSuperview:(UIView*)superView
{
    AKSwizzleMethodBackForParentClass(self, @selector(willMoveToSuperview:), @selector(UIView_ViewHook_willMoveToSuperview:), [UIView class], ^{
        [self UIView_ViewHook_willMoveToSuperview:superView];
        [self postNotificationName:kAKViewWillMoveToSuperViewNotification userInfo:superView ? @{@"view":superView} : nil];
    });
}

- (void)UIView_ViewHook_didMoveToSuperview
{
    AKSwizzleMethodBackForParentClass(self, @selector(didMoveToSuperview), @selector(UIView_ViewHook_didMoveToSuperview), [UIView class], ^{
        [self UIView_ViewHook_didMoveToSuperview];
        [self postNotificationName:kAKViewDidMoveToSuperViewNotification];
    });    
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
//ADD_BEHAVIOR_TO_CLASS(UITableViewCell, AKViewHookBehavior);
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


