//
//  AKFormCellCatalog.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-18.
//
//

#import "AKCommonUI.h"
#import <QuartzCore/QuartzCore.h>

@interface AKSelectorFormElement()
{
    NSMutableArray *_selectedIndices;
    NSArray *_selectedValues;
}

@property(nonatomic,strong,readwrite) NSArray *labels;
@property(nonatomic,strong,readwrite) NSArray *values;
@property(nonatomic,assign,readwrite) BOOL isReady;
@property(nonatomic,assign,readwrite, getter = isMultiSelect) BOOL multiSelect;
@property(nonatomic,strong,readwrite) AKListDataLoader* dataLoader;

@end

@implementation AKSelectorFormElement

+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(NSString *)labelText dataLoader:(id<AKListDataLoader>)dataLoader withTransformationBlock:(AKSelectorFormElementValueLabelTransformationBlock)block
        mutliSelect:(BOOL)multiSelect
{
    AKSelectorFormElement *formElement = [self selectorWithID:elementID labelText:labelText values:@[] mutliSelect:multiSelect];
    formElement.dataLoader = dataLoader;
    formElement.isReady    = NO;
    [formElement.dataLoader setCompletionBlockWithSuccess:^(NSArray *objects, NSUInteger page) {
        NSMutableArray *values, *labels;
        values = [NSMutableArray array];
        labels = [NSMutableArray array];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *value, *label;
                block(obj,&value,&label);
                [values addObject:value];
                [labels addObject:label];
        }];
        formElement.values  = values;
        formElement.labels  = labels;
        formElement.isReady = YES;
    } failure:nil];
    [formElement.dataLoader loadData];
    return formElement;
}

+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(NSString*)labelText values:(NSArray*)values mutliSelect:(BOOL)multiSelect
{
    NSMutableArray *vals, *labels;
    vals = [NSMutableArray array];
    labels = [NSMutableArray array];
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if ( [obj isKindOfClass:[NSArray class]] ) {
            NSAssert([obj count] == 2, @"Invalid array format");
           [vals addObject:[obj objectAtIndex:0]];
           [labels addObject:[obj objectAtIndex:1]];
       } else {
            [vals addObject:obj];
            [labels addObject:obj];
       }
    }];
    
    return [self selectorWithID:elementID labelText:labelText values:vals labels:labels mutliSelect:multiSelect];
}

+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(id)labelText values:(NSArray *)values labels:(NSArray *)labels
    mutliSelect:(BOOL)multiSelect
{
    AKSelectorFormElement *element = [super elementWithID:elementID];
    element.labelText = labelText;
    element.values    = values;
    element.labels    = labels;
    element.multiSelect = multiSelect;
    NSAssert(labels.count == values.count, @"Labels and Values size are not the same");
    return element;
}

- (id)init
{
    if ( self = [super init] ) {
        _selectedIndices = [NSMutableArray array];
        _selectedValues  = @[];
    }    
    return self;
}

- (void)setSelectedValues:(id)values
{
    if ( ![values isKindOfClass:[NSArray class]] ) {
        _selectedValues = @[values];
    } else {
        _selectedValues = values;
    }
}

- (BOOL)isValueAtIndexSelected:(NSUInteger)index
{
    return [_selectedIndices containsObject:[NSNumber numberWithInt:index]];
}

- (void)markValueAtIndex:(NSUInteger)index selected:(BOOL)selected
{
    NSNumber *object = [NSNumber numberWithInt:index];
    
    if ( selected ) {
        if ( !self.isMultiSelect ) {
            [self unSelectAllValues];
        }
        if ( ![_selectedIndices containsObject:object]) {
            [_selectedIndices addObject:object];
        }
    } else {
       [_selectedIndices removeObject:object];
    }
}

- (void)unSelectAllValues
{
    [_selectedIndices removeAllObjects];
}

- (NSArray*)selectedIndices
{
    return _selectedIndices;
}

- (Class)cellClass {
  return [AKSelectorFormElementCell class];
}

- (id)elementValue
{
    NSArray *array = [self.values arrayByFilteringObjectsUsingBlock:^BOOL(id obj, NSUInteger idx) {
            return [self isValueAtIndexSelected:idx];
    }];
    
    if ( array.count == 0 )
        return nil;
    if ( array.count == 1)
        return [array objectAtIndex:0];
    else
        return array;
}

@end

#pragma mark -
#pragma mark -

@interface AKSelectorFormElementCell() <UITableViewDelegate, UIGestureRecognizerDelegate, NITableViewModelDelegate>
{
    NITableViewModel *_tableModel;
    
    UIGestureRecognizer *_tapRecognizer;
    
    UIToolbar *_toolbar;
    UIView *_modalContainer;
    UIView *_selectorContainer;
}

@property(nonatomic, copy, readonly)  UITableView *selectorTableView;

@end

@implementation AKSelectorFormElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    style = UITableViewCellStyleValue1;
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
        [self addGestureRecognizer:recoginzer];        
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(AKSelectorFormElement*)object change:(NSDictionary *)change context:(void *)context
{
    [self initDefaultValues];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.detailTextLabel.text = @"";
    self.textLabel.text       = @"";
}

- (BOOL)shouldUpdateCellWithObject:(AKSelectorFormElement *)selectorElement {

    if ( self.element && self.element != selectorElement ) {
        [self.element removeObserver:self forKeyPath:@"isReady"];
    }
    
    if ( selectorElement.dataLoader ) {
        [selectorElement addObserver:self forKeyPath:@"isReady" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if ( [super shouldUpdateCellWithObject:selectorElement] ) {
        self.textLabel.text = selectorElement.labelText;
        if ( self.element.dataLoader && !self.element.isReady ) {
            self.detailTextLabel.text = @"Loading";
        } else {
            [self initDefaultValues];
        }
        return YES;
    }
    return NO;
}

- (void)initDefaultValues
{
    NSMutableArray *labels = [NSMutableArray array];
    for (NSString *value in self.element.selectedValues)
    {
        if ( [self.element.values containsObject:value] ) {
            int index = [self.element.values indexOfObject:value];
            NSString *label = [self.element.labels objectAtIndex:index];
            [labels addObject:label];
            [self.element markValueAtIndex:index selected:YES];
        }
    }
    self.detailTextLabel.text = labels.count > 0 ? [labels componentsJoinedByString:@", "] : @" ";
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((AKSelectorFormElement*)self.element).values.count;
}

- (void)didTapCell:(UITapGestureRecognizer*)gesture
{
    [self presentSelectorView];
}

- (void)presentSelectorView
{
    if ( self.element.dataLoader && !self.element.isReady ) {
        return;
    }
    
    UITableView *parentTableView = (UITableView*)self.superview;
    
    _modalContainer    = [[UIView alloc] initWithFrame:parentTableView.bounds];
    [parentTableView addSubview:_modalContainer];
    NSAssert(!_tapRecognizer, @"Tap recognizer should be null");
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutside:)];
    _tapRecognizer.delegate = self;
    [_modalContainer addGestureRecognizer:_tapRecognizer];
    
    _selectorContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [_modalContainer addSubview:_selectorContainer];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [_toolbar addStyleTag:@"FormSelectorToolbar"];
    
    if ( self.element.isMultiSelect ) {
        _toolbar.items = @[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelectorView)]
        ];
    }
    
    CGRect frame = AKRectSetXY(parentTableView.bounds, 0, 0);
    
    _selectorContainer.frame =
            CGRectOffset((AKRectGetRemainder(frame, CGRectGetHeight(frame) - 300, CGRectMinYEdge)), 0, 300);
    
    CGRect slice,remainder;
    CGRectDivide(_selectorContainer.bounds, &slice, &remainder, 44, CGRectMinYEdge);
    
    _toolbar.frame = slice;
    self.selectorTableView.frame = remainder;
    
    [_selectorContainer addSubview:_toolbar];
    [_selectorContainer addSubview:_selectorTableView];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.25 animations:^{
        _selectorContainer.frame = CGRectOffset(_selectorContainer.frame,0,-CGRectGetHeight(_selectorContainer.frame));
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissSelectorView
{
    //lets remove recgonizer
    NSAssert(_tapRecognizer, @"Tap recognizer should not be null");
    NSAssert(_selectorTableView, @"Selector can't be null");

    ///remove gesture recognizer on the parent
    [_selectorTableView.superview removeGestureRecognizer:_tapRecognizer];
    _tapRecognizer = nil;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.25 animations:^{
        _selectorContainer.frame = CGRectOffset(_selectorContainer.frame, 0, CGRectGetHeight(_selectorContainer.frame));
    } completion:^(BOOL finished) {
        _tableModel   = nil;
        [_modalContainer removeFromSuperview];
        _modalContainer    = nil;
        _selectorTableView = nil;
        _selectorContainer = nil;
    }];    
}

- (UITableView*)selectorTableView
{
    if ( !_selectorTableView ) {
        _selectorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_selectorContainer addStyleTag:@"FormSelectorTableView"];
        _tableModel = [[NITableViewModel alloc] initWithListArray:[[self.element labels] arrayByMappingObjectsUsingBlock:^id(id obj, NSUInteger idx) {
            return [NITitleCellObject objectWithTitle:obj];
        }] delegate:self];
        _selectorTableView.dataSource = _tableModel;
        _selectorTableView.delegate   = self;       
    }
    return _selectorTableView;
}

- (UITableViewCell*)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    UITableViewCell *cell = [[NICellFactory class] tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    [cell addStyleTag:@"FormSelectorTableViewCell"];
    if ( [self.element isValueAtIndexSelected:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == _tapRecognizer ) {
        NSAssert(_selectorTableView, @"Selector table view can't be null");
        CGPoint point = [gestureRecognizer locationInView:_selectorTableView];
        return !CGRectContainsPoint(_selectorTableView.bounds, point);
    }
    return YES;
}

- (void)didTapOutside:(UITapGestureRecognizer*)gestureRecognizer
{
    NSAssert(_selectorTableView, @"Selector table view can't be null");
    CGPoint point = [gestureRecognizer locationInView:_selectorTableView];
    if ( !CGRectContainsPoint(_selectorTableView.frame, point) ) {
        [self dismissSelectorView];
        //now lets remove recoginzer
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //if value already selected then unselect
    if ( [self.element isValueAtIndexSelected:indexPath.row] ) {
        [self.element markValueAtIndex:indexPath.row selected:NO];
        if ( self.element.selectedIndices.count > 0 ) {
            NSMutableArray* labels = [NSMutableArray array];
            [self.element.selectedIndices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               [labels addObject:[self.element.labels objectAtIndex:[obj integerValue]]];
            }];
            self.detailTextLabel.text = [labels componentsJoinedByString:@", "];
        } else {
            self.detailTextLabel.text = @"";
        }
    } else {
        //before marking lets remove the previous cell
        if ( !self.element.isMultiSelect && self.element.selectedIndices.count > 0 ) {
            NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:[[self.element.selectedIndices objectAtIndex:0] integerValue] inSection:0];
            UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:currentIndex];
            currentCell.accessoryType = UITableViewCellAccessoryNone;
        }
        [self.element markValueAtIndex:indexPath.row selected:YES];        
        NSMutableArray* labels = [NSMutableArray array];
        [self.element.selectedIndices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           [labels addObject:[self.element.labels objectAtIndex:[obj integerValue]]];
        }];
        self.detailTextLabel.text = [labels componentsJoinedByString:@", "];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if ( !self.element.isMultiSelect ) {
        [self dismissSelectorView];
    }
}

@end