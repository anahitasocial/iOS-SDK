//
//  AKFormCellCatalog.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-18.
//
//

@protocol AKListDataLoader;

/**
 @typedef
 
*/
typedef void(^AKSelectorFormElementValueLabelTransformationBlock)(id object, NSString** value, NSString** label);

/**
 @@protocol NIFormElement 

 @abstract
*/
@protocol AKFormElement <NSObject>

@required

/** @asbtract */
@property (nonatomic, readonly) id elementValue;

@end

/**
 @class AKSelectorFormElement

 @abstract
 
*/
@interface AKSelectorFormElement : NIFormElement <AKFormElement>

/**
 @method

 @abstract
*/
+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(NSString*)labelText
    dataLoader:(id<AKListDataLoader>)dataLoader withTransformationBlock:(AKSelectorFormElementValueLabelTransformationBlock)block
    mutliSelect:(BOOL)multiSelect
    ;

/**
 @method

 @abstract
*/
+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(NSString*)labelText
    values:(NSArray*)values
    mutliSelect:(BOOL)multiSelect
    ;

/**
 @method

 @abstract
*/
+ (instancetype)selectorWithID:(NSInteger)elementID labelText:(NSString*)labelText values:(NSArray*)values
        labels:(NSArray*)labels
        mutliSelect:(BOOL)multiSelect
        ;


/**
 @method

 @abstract
*/
- (BOOL)isValueAtIndexSelected:(NSUInteger)index;

/**
 @method

 @abstract
*/
- (void)markValueAtIndex:(NSUInteger)index selected:(BOOL)selected;

/**
 @method

 @abstract
*/
- (void)unSelectAllValues;

/** @abstract */
@property(nonatomic,readonly) NSArray *selectedIndices;

/** @abstract */
@property(nonatomic,strong) id selectedValues;

/** @abstract */
@property(nonatomic,readonly) id value;

/** @abstract */
@property(nonatomic,copy,readwrite) NSString *labelText;

@end

#pragma mark -

/**
 @class AKSelectorFormElement

 @abstract
 
*/
@interface AKSelectorFormElementCell : NIFormElementCell <UIPickerViewDataSource>
{
    @protected

    //contains the selection
    UITableView *_selectorTableView;
}

/** @abstract */
@property(nonatomic, readonly, strong) AKSelectorFormElement* element;

@end