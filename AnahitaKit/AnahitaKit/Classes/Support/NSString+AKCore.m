//
//  NSString+AKCore.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "NSDictionary+RKAdditions.h"

@implementation NSString (AKCore)

- (NSArray*)componentsSeparatedByCases
{
    NSString *word = AKNSRegularExpressionReplace(self, @"\\s+", @"_", nil);
    word = [AKNSRegularExpressionReplace(word, @"(?<=\\w)([A-Z])",@"_$1", nil) lowercaseString];
    return [word componentsSeparatedByString:@"_"];
}

- (NSString *)stringByAppendingDictionaryQueryParamaters:(NSDictionary*)queryParameters
{
    NSString *query = [queryParameters stringWithURLEncodedEntries];
    return [self stringByAppendingStringQueryParamaters:query];
}

- (NSString *)stringByAppendingStringQueryParamaters:(NSString*)queryParameters
{
    NSString *newString;
    
    if ( nil != queryParameters ) {
        
        newString = AKNSRegularExpressionReplace(self, @"\\?$", @"", nil);
        
        if ([newString rangeOfString:@"?"].location == NSNotFound) {
            newString = [newString stringByAppendingFormat:@"?%@", queryParameters];
            
        } else {
            newString = [newString stringByAppendingFormat:@"&%@", queryParameters];
        }
    }
    
    else {
        newString = [NSString stringWithString:self];
    }
    
    return newString;
}

- (NSUInteger)countOccurancesOfSubstring:(NSString *)substring
{
    const char * rawNeedle = [substring UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    
    const char * rawHaystack = [self UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; //they don't match; reset the needle index
        }
        
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; //char match
            if (needleIndex >= needleLength) {
                needleCount++; //we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    
    return needleCount;
}

@end
