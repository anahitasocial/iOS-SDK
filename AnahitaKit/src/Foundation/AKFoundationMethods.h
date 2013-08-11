//
//  AKFoundationMethods.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#pragma mark -
#pragma mark Macros


#define TYPEDEF_CLASS(existing, new) \
    @interface new : existing @end @implementation new @end



#define inline_block(code) (id)^{code}()

/**
 * For filling in gaps in Apple's Foundation framework.
 *
 *
 * Utility methods save time and headache.  
 */

#pragma mark -

/**
 @method
  
 @abstract
 */
NSString * AKLocalizedString(NSBundle *bundle, NSString *key, NSString *comment);

#undef NSLocalizedString
#define NSLocalizedString(key,_comment) AKLocalizedString([NSBundle mainBundle], key, _comment)


#pragma mark -
#pragma mark NSRegularExpression Methods

/**
 * Regular expression quick methods
 */

/**
  @method
  
  Searches string for matches to regular expression pattern and replaces them with the replacement
 
  @return A new string
 */
NSString * AKNSRegularExpressionReplace(NSString *string, NSString *pattern, NSString *replacement, NSError **error);


/**
 @method
 
 Test if a string matches a regular expression pattern
 
 @return True or False depending whether the string matches the pattern
 */
BOOL AKNSRegularExpressionMatch(NSString *string, NSString *pattern, NSError **error);

/**
 @method
 
 @abstract
 Return the first class found or nil
 
 @return True or False depending whether the string matches the pattern
 */
Class AKNSClassFromListOfStrings(NSString * class1,...);


/**
 @method
 
 @abstract
 Return the subclasses of a parent class
 
 @return An array of subclasses
 */
NSArray *AKSubclassesOfClass(Class class);


/**
 @method
 
 @abstract
 
 */
Class class_getImplementingClass(Class class, SEL selector);

/**
 @method
 
 @abstract
 
 */
BOOL class_selectorInMethodList(Class class, SEL selector);

/**
 @method
 
 @abstract

 */
BOOL class_copyMethod(Class sourceClass, SEL sourceSelector, Class targetClass, SEL targetSelector);

/**
 @method
 
 @abstract

 */
BOOL class_copyMethods(Class sourceClass, Class targetClass, SEL method1, ...);

/**
 @method
 
 @abstract
 
 */
NSArray *class_getMethodList(Class class);