//
//  UIView+AKStyler
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-02.
//
//

#import "UIView+AKStyler.h"
#import <objc/runtime.h>

NSString *const kAKStylerDidAddStyleTagToViewNotification = @"kAKStylerDidAddStyleTagToViewNotification";
NSString *const kAKStylerDidRemoveStyleTagFromViewNotification = @"kAKStylerDidRemoveStyleTagFromViewNotification";

@implementation NSNotification(AKStyler)

- (NSString*)styleTag
{
    return [self.userInfo valueForKey:@"styleTag"];
}

@end

@interface UIView()

@property(nonatomic,readonly) NSMutableSet *_stylerTags;

@end

@implementation UIView (AKStyler)

- (NSMutableSet*)_stylerTags
{
    if ( !objc_getAssociatedObject(self, @"styleTags") ) {
        objc_setAssociatedObject(self, @"styleTags", [NSMutableSet set], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, @"styleTags");
}

- (void)addStyleTag:(NSString *)styleTag
{
    if ( ![self._stylerTags containsObject:styleTag] )
    {
        [self._stylerTags addObject:styleTag];
        
        NSNotification *notification = [NSNotification notificationWithName:kAKStylerDidAddStyleTagToViewNotification
                object:[self class] userInfo:@{@"view":self,@"styleTag":styleTag}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (BOOL)hasStyleTag:(NSString*)styleTag
{
    return [self._stylerTags containsObject:styleTag];
}

- (void)removeStyleTag:(NSString*)styleTag
{
    if ( ![self._stylerTags containsObject:styleTag] )
    {
        [self._stylerTags removeObject:styleTag];
        
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
