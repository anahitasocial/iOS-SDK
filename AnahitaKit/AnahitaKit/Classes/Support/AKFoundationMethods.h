//
//  AKFoundationMethods.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 * For filling in gaps in Apple's Foundation framework.
 *
 *
 * Utility methods save time and headache.  
 */

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