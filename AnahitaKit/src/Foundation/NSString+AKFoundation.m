//
//  NSString+AKCore.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKFoundationMethods.h"
#import "AKInflection.h"
#import "NSArray+AKFoundation.h"


@implementation NSString (AKCore)

- (NSString *)camelCasedString
{
    return [[[self componentsSeparatedByCases] arrayByMappingObjectsUsingBlock:^id(id obj, NSUInteger idx) {
            return [obj capitalizedString];
    }] componentsJoinedByString:@""];
}

- (NSArray*)componentsSeparatedByCases
{
    NSString *word = AKNSRegularExpressionReplace(self, @"\\s+|-", @"_", nil);
    word = [AKNSRegularExpressionReplace(word, @"(?<=\\w)([A-Z])",@"_$1", nil) lowercaseString];
    return [word componentsSeparatedByString:@"_"];
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

- (NSString *)pluralizedString
{
    return [[AKInflection sharedInflection] pluralize:self];
}

- (NSString *)singularizedString
{
    return [[AKInflection sharedInflection] singularize:self];
}

@end
