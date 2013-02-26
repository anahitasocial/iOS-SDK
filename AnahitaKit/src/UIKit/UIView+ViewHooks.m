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

@implementation UIView(ViewHooks)

SYNTHESIZE_PROPERTY_COPY(AKViewLayoutSubViewsBlock, setBeforeLayoutSubViewsBlock, beforeLayoutSubViewsBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewLayoutSubViewsBlock, setLayoutSubViewsBlock, layoutSubViewsBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewLayoutSubViewsBlock, setAfterLayoutSubViewsBlock, afterLayoutSubViewsBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewDrawRectBlock, setBeforeDrawRectBlock, beforeDrawRectBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewDrawRectBlock, setDrawRectBlock, drawRectBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewDrawRectBlock, setAfterDrawRectBlock, afterDrawRectBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewDidAddSubViewBlock, setDidAddSubViewBlock, didAddSubViewBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewWillRemoveSubViewBlock, setWillRemoveSubViewBlock, willRemoveSubViewBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewWillMoveToSuperViewBlock, setWillMoveToSuperViewBlock, willMoveToSuperViewBlock);
SYNTHESIZE_PROPERTY_COPY(AKViewDidMoveToSuperView, setDidMoveToSuperViewBlock, didMoveToSuperViewBlock);

@end

#pragma mark -

/*
extern NSString *const kAKUIViewWillLayoutSubViewsNotification;
extern NSString *const kAKUIViewDidLayoutSubViewsNotification;
extern NSString *const kAKUIViewWillDrawRectNotification;
extern NSString *const kAKUIViewDidDrawRectNotification;
*/

//NSString *const kAKViewWillInitNotification = @"kAKViewWillInitNotification";
NSString *const kAKViewDidInitNotification = @"kAKViewDidInitNotification";
//NSString *const kAKUIViewWillLayoutSubViewsNotification = @"kAKUIViewWillLayoutSubViewsNotification";
//NSString *const kAKUIViewDidLayoutSubViewsNotification = @"kAKUIViewDidLayoutSubViewsNotification";
//NSString *const kAKUIViewWillDrawRectNotification = @"kAKUIViewWillDrawRectNotification";
//NSString *const kAKUIViewDidDrawRectNotification = @"kAKUIViewDidDrawRectNotification";


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
        Class class = [object class];

        while (!class_conformsToProtocol(class, @protocol(AKViewHookBehavior))) {
            class = class_getSuperclass(class);
        }
        
        AKSwizzleMethodBackForParentClass(class_getSuperclass(class), oldMethod, newMethod, stopClass, nil);
        callback();
        AKSwizzleMethodBackForParentClass(class_getSuperclass(class), oldMethod, newMethod, stopClass, nil);
    }
    else {
        if ( class_conformsToProtocol(object, @protocol(AKViewHookBehavior))        
        ) {
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

+ (void)mixinDidMixSelectors:(NSMutableArray *)selectors withClass:(Class)class
{    
    if ( [class isSubclassOfClass:[UITableView class]]) {
        [self exchangeMethod:@selector(UITableView_ViewHook_initWithFrame:style:) withClass:class selector:@selector(initWithFrame:style:)];
    }    
    else if ( [class isSubclassOfClass:[UITableViewCell class]]) {
        [self exchangeMethod:@selector(UITableViewCell_ViewHook_initWithStyle:reuseIdentifier:) withClass:class selector:@selector(initWithStyle:reuseIdentifier:)];
    }
    else {
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
    if ( self.beforeLayoutSubViewsBlock ) {
        self.beforeLayoutSubViewsBlock();
    }
    
    AKSwizzleMethodBackForParentClass(self, @selector(layoutSubviews), @selector(UIView_ViewHook_layoutSubviews), [UIView class], ^{
        if ( self.layoutSubViewsBlock ) {
            self.layoutSubViewsBlock();
        }
        [self UIView_ViewHook_layoutSubviews];
    });
    
    if ( self.afterLayoutSubViewsBlock ) {
        self.afterLayoutSubViewsBlock();
    }
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
    if ( self.beforeDrawRectBlock ) {
        self.beforeDrawRectBlock(rect);
    }
    
    AKSwizzleMethodBackForParentClass(self, @selector(drawRect:), @selector(UIView_ViewHook_drawRect:), [UIView class], ^{
        if ( self.drawRectBlock ) {
            self.drawRectBlock(rect);
        }        
        [self UIView_ViewHook_drawRect:rect];
    });
    
    if ( self.afterDrawRectBlock ) {
        self.afterDrawRectBlock(rect);
    }
}

- (void)UIView_ViewHook_didAddSubView:(UIView*)subview
{
    AKSwizzleMethodBackForParentClass(self, @selector(didAddSubview:), @selector(UIView_ViewHook_didAddSubView:), [UIView class], ^{
        if ( self.didAddSubViewBlock ) {
            self.didAddSubViewBlock(subview);
        }    
        [self UIView_ViewHook_didAddSubView:subview];
    });
}

- (void)UIView_ViewHook_willRemoveSubview:(UIView*)subview
{
    AKSwizzleMethodBackForParentClass(self, @selector(willRemoveSubview:), @selector(UIView_ViewHook_willRemoveSubview:), [UIView class], ^{
        if ( self.willRemoveSubViewBlock ) {
            self.willRemoveSubViewBlock(subview);
        }    
        [self UIView_ViewHook_willRemoveSubview:subview];
    });
}

- (void)UIView_ViewHook_willMoveToSuperview:(UIView*)superView
{
    AKSwizzleMethodBackForParentClass(self, @selector(willMoveToSuperview:), @selector(UIView_ViewHook_willMoveToSuperview:), [UIView class], ^{
        if ( self.willMoveToSuperViewBlock ) {
            self.willMoveToSuperViewBlock(superView);
        }
        [self UIView_ViewHook_willMoveToSuperview:superView];
    });
}

- (void)UIView_ViewHook_didMoveToSuperview
{
    AKSwizzleMethodBackForParentClass(self, @selector(didMoveToSuperview), @selector(UIView_ViewHook_didMoveToSuperview), [UIView class], ^{
        if ( self.didMoveToSuperViewBlock ) {
            self.didMoveToSuperViewBlock();
        }    
        [self UIView_ViewHook_didMoveToSuperview];
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


#pragma mark - Overloading existing views

@interface UIView_ : UIView
@end

@implementation UIView_
@end

@implementation UIView(HookableView)

+ (UIView*)viewWithFrame:(CGRect)frame;
{
    return [[UIView_ alloc] initWithFrame:frame];
}

@end

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


