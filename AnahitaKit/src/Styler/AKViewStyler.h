//
//  AKCssStyler.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-03.
//
//

@class AKViewStyler;

@class NIStylesheet;

@interface AKViewStyler : NSObject
{
    @protected
    NIStylesheet *_styleSheet;
    NSMutableOrderedSet *_classesAsTags;
}

/**
 @method
 
 @abstract
*/
- (id)initWithStyleSheet:(NIStylesheet*)stylesheet;

/**
 @method
 
 @abstract
*/
//- (void)tagClass:(Class)class with:(NSString*)tag;

/**
 @method
 
 @abstract
*/
- (void)didAddStyleTag:(NSString*)styleTag toView:(UIView*)view;

/** @abstract */
@property(nonatomic,readonly) NIStylesheet* stylesheet;

@end
