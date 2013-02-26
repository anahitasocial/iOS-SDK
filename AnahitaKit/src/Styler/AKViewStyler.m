//
//  AKCssStyler.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-03.
//
//

#import "AKStyler.h"
#import "AKUIKit.h"
#import "NSString+AKFoundation.h"

@interface AKViewStyler(Private)

@end

@implementation AKViewStyler

-(id)initWithStyleSheet:(NIStylesheet *)stylesheet
{
    if ( self = [self init] ) {
        _styleSheet = stylesheet;
    }    
    return self;
}

- (id)init
{
    if ( self = [super init] )
    {
        _classesAsTags = [[NSMutableOrderedSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInitViewNotification:) name:kAKViewDidInitNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddStyleTagToViewNotification:) name:kAKStylerDidAddStyleTagToViewNotification object:nil];
        
        [_classesAsTags addObjectsFromArray:
            @[[UIToolbar class],[UINavigationBar class],[UITableViewCell class],[UITableView class],
            [UISearchBar class],[UIButton class],[UILabel class]]];        
    }
    
    return self;
}

- (void)didAddStyleTag:(NSString*)styleTag toView:(UIView*)view
{
   NSString *strSelector = [NSString stringWithFormat:@"addStyle%@:", [styleTag camelCasedString]];
   SEL selector = NSSelectorFromString(strSelector);
   if ( [self respondsToSelector:selector] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:view];
#pragma clang diagnostic pop       
   }
}

#pragma mark handle kAKUIViewDidInitNotification

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

- (void)didAddStyleTagToViewNotification:(NSNotification*)notification
{
    [self didAddStyleTag:notification.styleTag toView:notification.view];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
