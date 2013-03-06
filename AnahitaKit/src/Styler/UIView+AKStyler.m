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


NSString *const kAKStylerDidAddStyleTagToViewNotification = @"kAKStylerDidAddStyleTagToViewNotification";
NSString *const kAKStylerDidRemoveStyleTagFromViewNotification = @"kAKStylerDidRemoveStyleTagFromViewNotification";

@implementation NSNotification(AKStyler)

- (NSString*)styleTag
{
    return [self.userInfo valueForKey:@"styleTag"];
}

@end

@interface UIView()

@property(nonatomic,readonly) NSMutableSet *styleTags;

@end

@implementation UIView (AKStyler)

SYNTHESIZE_PROPERTY_STRONG(NSMutableSet*, _styleTags, _styleTags)

- (NSMutableSet*)styleTags
{
    if ( ![self _styleTags] ) {
        [self _styleTags:[NSMutableSet set]];
    }
    
    return [self _styleTags];
}

- (void)addStyleTag:(NSString *)styleTag
{
    if ( ![self.styleTags containsObject:styleTag] )
    {
        [self.styleTags addObject:styleTag];
        
        NSNotification *notification = [NSNotification notificationWithName:kAKStylerDidAddStyleTagToViewNotification
                object:[self class] userInfo:@{@"view":self,@"styleTag":styleTag}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (BOOL)hasStyleTag:(NSString*)styleTag
{
    return [self.styleTags containsObject:styleTag];
}

- (void)removeStyleTag:(NSString*)styleTag
{
    if ( ![self.styleTags containsObject:styleTag] )
    {
        [self.styleTags removeObject:styleTag];
        
        NSNotification *notification = [NSNotification notificationWithName:kAKStylerDidRemoveStyleTagFromViewNotification
                object:[self class] userInfo:@{@"view":self,@"styleTag":styleTag}];
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
