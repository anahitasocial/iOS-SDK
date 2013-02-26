//
//  AKListViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKCommonUI.h"
#import <objc/runtime.h>
#import "NimbusCSS.h"
#import "JRSwizzle.h"

@interface NIFormElement(Private)
- (id)value;
@end

@interface AKFormViewController : NSObject <AKMixin>

@end

@implementation AKFormViewController

+ (BOOL)mixinShouldMixWithClass:(Class)class
{
    return [class isSubclassOfClass:[UIViewController class]];
}

+ (void)mixinDidMixSelectors:(NSMutableArray *)selectors withClass:(Class)class
{
    class_copyMethod(self, @selector(formElements), class, @selector(formElements));
    class_copyMethod(self, @selector(AKFormViewController_loadView), class, @selector(AKFormViewController_loadView));
    [class jr_swizzleMethod:@selector(loadView) withMethod:@selector(AKFormViewController_loadView) error:nil];
}

- (void)AKFormViewController_loadView
{
    [self AKFormViewController_loadView];
    [self tableView];   
}

- (NITableViewActions*)tableActions
{
    NITableViewActions *tableActions = objc_getAssociatedObject(self, @"tableActions");
    if ( !tableActions ) {
        tableActions = [[NITableViewActions alloc] initWithTarget:self];
        [self tableView].delegate = [tableActions forwardingTo:(id<UITableViewDelegate>)self];
        objc_setAssociatedObject(self, @"tableActions", tableActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableActions;
}

- (NIMutableTableViewModel*)tableModel
{
    NIMutableTableViewModel *tableModel = objc_getAssociatedObject(self, @"tableModel");
    if ( !tableModel ) {
        tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        [self tableView].dataSource = tableModel;
        objc_setAssociatedObject(self, @"tableModel", tableModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableModel;
}

- (id)addFormElement:(NSString*)name element:(id<AKFormElement>)element
{
    NSMutableDictionary *formElements = [self formElements];
    [formElements setValue:element forKey:name];
    [[self tableModel] addObject:element];
    return element;
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

- (UITableView*)tableView
{
    UITableView *tableView = objc_getAssociatedObject(self, @"tableView");
    if ( !tableView ) {
        MIXER_VAR(UIViewController*);
        UITableViewStyle tableViewStyle = [self tableViewStyle];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
        objc_setAssociatedObject(self, @"tableView", tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [mixer.view addSubview:tableView];
        //nothign has changed
        if ( CGRectEqualToRect(tableView.frame,CGRectZero) ) {
            tableView.frame = mixer.view.bounds;
        }
    
    }
    return tableView;
}

- (NSDictionary*)formValues
{
    NSDictionary *values = [[self formElements] dictionaryByMappingObjectsUsingBlock:^id(id key, id<AKFormElement>obj) {
        if ( [obj respondsToSelector:@selector(elementValue)] ) {
            id value = [obj elementValue];
            SEL attributeSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Value:", key]);
            if ( [self respondsToSelector:@selector(attributeSelector)] ) {
                value = [self performSelector:@selector(attributeSelector) withObject:value];
            }
            if ( !value ) {
                value = [NSNull null];
            }
            return value;
        } else {
            return [NSNull null];
        }
    }];
    
    return [values dictionaryByReducingObjectsUsingBlock:^BOOL(id key, id obj) {
        return ![obj isKindOfClass:[NSNull class]];
    }];
}

- (NSMutableDictionary*)formElements
{
    NSMutableDictionary *formElements = objc_getAssociatedObject(self, @"formElements");
    if ( !formElements ) {
        formElements = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @"formElements", formElements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return formElements;
}

@end
