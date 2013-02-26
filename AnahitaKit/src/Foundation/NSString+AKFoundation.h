//
//  NSString+AKCore.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@interface NSString (AKCore)

/**
 @method
 
 @abstract
 Camel cases
 */
- (NSString *)camelCasedString;

/**
 @method
 
 @abstract
 Splits a string into components seperated by case
 */
- (NSArray *)componentsSeparatedByCases;

/**
 @method
 
 @abstract
 Returns a pluralize the string
 */
- (NSString *)pluralizedString;

/**
 @method
 
 @abstract
 Returns a pluralize the string
 */
- (NSString *)singularizedString;

/**
 @method
 
 @abstract
 Counts the occurances of a substring
 */
- (NSUInteger)countOccurancesOfSubstring:(NSString*)substring;

@end
