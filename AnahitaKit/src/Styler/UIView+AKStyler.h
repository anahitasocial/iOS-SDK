//
//  UIView+AKCSS.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-02.
//
//

/**
 @category
 
 @abstract
 Provides a readonly propery to get a style tag
*/
@interface NSNotification(AKStyler)

@property(nonatomic,readonly) NSString* styleTag;

@end

/**
 @category
 
 @abstract
 Provides a mechanism to store styler tags for a view. When a css class for view is set
 a notification is dispatched that allows observers to style the view
*/
@interface UIView (AKStyler)

/**
 @method
 
 @abstract
 Adds a style tag
 
 @param The tag
*/
- (void)addStyleTag:(NSString*)tag;

/**
 @method
 
 @abstract
 Returns if a view has a style tag
 
 @param the style tag
 @return True if it has a class or false other wise
*/
- (BOOL)hasStyleTag:(NSString*)styleTag;

/**
 @method
 
 @abstract
 Removes style tag
 
 @param style tag
*/
- (void)removeStyleTag:(NSString*)styleTag;

/**
 @method
 
 @abstract
 Return the first view that matches a view class
 
 @param style tag 
*/
- (UIView*)subViewOfClass:(Class)class;

/**
 @method
 
 @abstract
 Return the first view that matches a style tag
 
 @param style tag
*/
- (UIView*)viewWithStyleTag:(NSString*)styleTag;

@end

/**
 @abstract Dispatched when a css class is added to the view
*/
extern NSString *const kAKStylerDidAddStyleTagToViewNotification;

/**
 @abstract Dispatched when a css class is removed from a view
*/
extern NSString *const kAKStylerDidRemoveStyleTagFromViewNotification;
