//
//  AKApplicationStyle.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-03-06.
//
//

@class AKViewStyler;

/**
 @typedef
 
 @abstract
*/
typedef void(^AKStylerUndoStyleBlock)();

@interface AKApplicationStyle : NSObject
{

    @protected
    NSMutableArray *_viewStylers;
    NSMutableOrderedSet *_classesAsTags;
}

/**
 @method
 
 @abstract
*/
+ (instancetype)defaultStyle;

/**
 @method
 
 @abstract
*/
- (void)addViewStyler:(id)aViewStyler;

/**
 @method
 
 @abstract
*/
- (void)removeViewStyler:(id)aViewStyler;

@end
