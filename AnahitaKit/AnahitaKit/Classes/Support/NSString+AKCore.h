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
 Splits a string into components seperated by case
 */
- (NSArray*)componentsSeparatedByCases;

/**
 @method
 
 @abstract
 Adds parameters to the end a string
 */
- (NSString *)stringByAppendingDictionaryQueryParamaters:(NSDictionary*)queryParameters;

/**
 @method
 
 @abstract
 Adds parameters to the end a string
 */
- (NSString *)stringByAppendingStringQueryParamaters:(NSString*)queryParameters;

/**
 @method
 
 @abstract
 Counts the occurances of a substring
 */
- (NSUInteger)countOccurancesOfSubstring:(NSString*)substring;

@end
