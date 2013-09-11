//
//  UIView+AKStyler
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-02.
//
//

#import "UIView+AKStyler.h"
#import <objc/runtime.h>
#import "NSObject+AKFoundation.h"
#import "UIView+ViewHooks.h"

NSString *const kAKStylerDidAddStyleTagToViewNotification = @"kAKStylerDidAddStyleTagToViewNotification";
NSString *const kAKStylerDidRemoveStyleTagFromViewNotification = @"kAKStylerDidRemoveStyleTagFromViewNotification";
NSString *const kAKStyleStyleTagUserInfoKey = @"kAKStyleStyleTagUserInfoKey";

@interface UIView()

@property(nonatomic,readonly) NSMutableSet *styleTags;

@end

@implementation UIView (AKStyler)

SYNTHESIZE_PROPERTY(NSMutableSet*, setStyleTags, styleTags , OBJC_ASSOCIATION_RETAIN_NONATOMIC, [NSMutableSet set]);

- (UIView*)addSubview:(UIView *)view withStyleTag:(NSString*)styleTag
{
    [self addSubview:view];
    [view addStyleTag:styleTag];
    return view;
}

- (void)addStyleTag:(NSString *)styleTag
{
    if ( ![self.styleTags containsObject:styleTag] )
    {
        [self.styleTags addObject:styleTag];
        
        NSNotification *notification = [NSNotification notificationWithName:kAKStylerDidAddStyleTagToViewNotification
                object:self userInfo:@{kAKStyleStyleTagUserInfoKey:styleTag}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)addStyleTags:(NSString *)tag1, ...
{
    va_list args;
    va_start(args, tag1);
    for(NSString* styleTag = tag1; styleTag != nil; styleTag=va_arg(args, NSString*)) {
        [self addStyleTag:styleTag];
    }
    va_end(args);
}

- (BOOL)hasStyleTag:(NSString*)styleTag
{
    return [self.styleTags containsObject:styleTag];
}

- (void)removeStyleTag:(NSString*)styleTag
{
    if ( [self.styleTags containsObject:styleTag] )
    {
        [self.styleTags removeObject:styleTag];
        
        NSNotification *notification = [NSNotification notificationWithName:kAKStylerDidRemoveStyleTagFromViewNotification
                object:self userInfo:@{kAKStyleStyleTagUserInfoKey:styleTag}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];        
    }
}

- (UIView*)subViewOfClass:(Class)class
{
    __block UIView *found = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ( [obj isMemberOfClass:class] ) {
            found = obj;
            *stop = YES;
        }
    }];
    return found;
}


- (UIView*)viewWithStyleTag:(NSString *)styleTag
{
    __block UIView *subview = NULL;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ( [obj hasStyleTag:styleTag] ) {
            subview = obj;
            *stop = YES;
        }
    }];
    return subview;
}

@end
