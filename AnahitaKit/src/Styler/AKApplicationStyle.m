//
//  AKApplicationStyle.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-03-06.
//
//

#import "AKStyler.h"
#import "AKUIKit.h"
#import "NSString+AKFoundation.h"

@implementation AKApplicationStyle

+ (instancetype)defaultStyle
{
    static dispatch_once_t onceToken;
    static AKApplicationStyle *defaultStyle;
    dispatch_once(&onceToken, ^{
        defaultStyle = [self new];
    });
    return defaultStyle;
}

- (id)init
{
    if ( self = [super init] )
    {
        _viewStylers = [NSMutableArray array];
        
        _classesAsTags = [[NSMutableOrderedSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInitViewNotification:) name:kAKViewDidInitNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddStyleTagToViewNotification:) name:kAKStylerDidAddStyleTagToViewNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveStyleTagFromViewNotification:) name:kAKStylerDidRemoveStyleTagFromViewNotification object:nil];
        
        [_classesAsTags addObjectsFromArray:
            @[[UIToolbar class],[UINavigationBar class],[UITableViewCell class],[UITableView class],
            [UISearchBar class],[UIButton class],[UILabel class]]];
    }    
    return self;
}

- (void)addViewStyler:(id)aViewStyler
{
    [_viewStylers addObject:aViewStyler];
}

- (void)removeViewStyler:(id)aViewStyler
{
    [_viewStylers removeObject:aViewStyler];
}

#pragma mark handle Notifications

- (void)didInitViewNotification:(NSNotification *)notification
{
    UIView *view = notification.view;
    
    [_classesAsTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [view isKindOfClass:(Class)obj]) {
            [view addStyleTag:NSStringFromClass(obj)];
        }
    }];
    
    NSString* tag = NSStringFromClass([view class]);
    [view addStyleTag:tag];
}

- (void)didRemoveStyleTagFromViewNotification:(NSNotification*)notification
{
    UIView *view = (UIView*)notification.object;
    NSString *styleTag = [notification.userInfo valueForKey:kAKStyleStyleTagUserInfoKey];
    NSString *strSelector = [NSString stringWithFormat:@"undoStyle%@:", [styleTag camelCasedString]];
    SEL selector = NSSelectorFromString(strSelector);
    [_viewStylers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           if ( [obj respondsToSelector:selector] ) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [obj performSelector:selector withObject:view];
        #pragma clang diagnostic pop       
           }
    }];    
}

- (void)didAddStyleTagToViewNotification:(NSNotification*)notification
{
    UIView *view = (UIView*)notification.object;
    NSString *styleTag = [notification.userInfo valueForKey:kAKStyleStyleTagUserInfoKey];
    NSString *strSelector = [NSString stringWithFormat:@"style%@:", [styleTag camelCasedString]];
    SEL selector = NSSelectorFromString(strSelector);
    [_viewStylers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           if ( [obj respondsToSelector:selector] ) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [obj performSelector:selector withObject:view];
        #pragma clang diagnostic pop       
           }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
