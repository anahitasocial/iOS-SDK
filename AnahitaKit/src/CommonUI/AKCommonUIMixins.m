//
//  AKListViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKCommonUI.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

@interface NIFormElement(Private)
- (id)value;
@end

@interface AKFormViewController : NSObject <AKMixin>

@end

@implementation AKFormViewController

SYNTHESIZE_PROPERTY_STRONG(UITableView*, _setTableView, _tableView);
SYNTHESIZE_PROPERTY_STRONG(NITableViewActions*, _setTableActions, _tableActions);
SYNTHESIZE_PROPERTY_STRONG(NIMutableTableViewModel*, _setTableModel, _tableModel);
SYNTHESIZE_PROPERTY(NSNumber*, _setTableViewStyle, _tableViewStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC, [NSNumber numberWithInt:UITableViewStyleGrouped]);
SYNTHESIZE_PROPERTY(NSMutableDictionary*, _setFormElements, _formElements, OBJC_ASSOCIATION_RETAIN_NONATOMIC, [NSMutableDictionary dictionary]);

+ (BOOL)mixinShouldMixWithClass:(Class)class
{
    return [class isSubclassOfClass:[UIViewController class]];
}

+ (void)mixinDidMixSelectors:(NSMutableArray *)selectors withClass:(Class)class
{
    class_copyMethods(self, class,
            @selector(AKFormViewController_loadView),
            @selector(_setTableView:),    @selector(_tableView),
            @selector(_setTableModel:),   @selector(_tableModel),
            @selector(_setTableViewStyle:),   @selector(_tableViewStyle),
            @selector(_setTableActions:), @selector(_tableActions),
            @selector(_setFormElements:), @selector(_formElements),nil
    );
    
    [class jr_swizzleMethod:@selector(loadView) withMethod:@selector(AKFormViewController_loadView) error:nil];
}

- (void)AKFormViewController_loadView
{
    [self AKFormViewController_loadView];
    [self tableView];   
}

- (NITableViewActions*)tableActions
{
    NITableViewActions *tableActions = [self _tableActions];
    if ( !tableActions ) {
        tableActions = [[NITableViewActions alloc] initWithTarget:self];
        [self tableView].delegate = [tableActions forwardingTo:(id<UITableViewDelegate>)self];
        [self _setTableActions:tableActions];
    }
    return tableActions;
}

- (NIMutableTableViewModel*)tableModel
{
    NIMutableTableViewModel *tableModel = [self _tableModel];
    if ( !tableModel ) {
        tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        [self tableView].dataSource = tableModel;
        [self _setTableModel:tableModel];
    }
    return tableModel;
}

- (void)addFormSpace
{
    [[self tableModel] addSectionWithTitle:@""];
}


- (id<NICellObject>)addButton:(NSString*)title action:(void(^)())actionBlock
{
    NITitleCellObject *cellObject = [NITitleCellObject objectWithTitle:title];
    [[self tableModel] addObject:cellObject];
    [[self tableActions] attachToObject:cellObject tapBlock:^BOOL(id object, id target) {
        actionBlock();
        return YES;
    }];
    return cellObject;
}

- (id)addFormElement:(NSString*)name element:(id<AKFormElement>)element
{
    NSMutableDictionary *formElements = [self _formElements];
    [formElements setValue:element forKey:name];
    [[self tableModel] addObject:element];
    return element;
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
    [self _setTableViewStyle:[NSNumber numberWithInt:tableViewStyle]];
}

- (UITableViewStyle)tableViewStyle
{
    return [[self _tableViewStyle] intValue];
}

- (UITableView*)tableView
{
    UITableView *tableView = [self _tableView];
    if ( !tableView ) {
        MIXER_VAR(UIViewController*);
        UITableViewStyle tableViewStyle = [self tableViewStyle];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
        [self _setTableView:tableView];
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
    NSDictionary *values = [[self _formElements] dictionaryByMappingObjectsUsingBlock:^id(id key, id<AKFormElement>obj) {
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

@end
