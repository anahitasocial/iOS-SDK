//
//  NSString+AKRestKit.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-16.
//
//

@interface NSString (AKRestKit)

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

@end
