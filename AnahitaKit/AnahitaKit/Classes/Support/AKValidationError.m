//
//  AKError.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-09.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKValidationError.h"
#import "RestKit.h"
#import <objc/runtime.h>

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

NSString *const kAKValueIsNotUniqueError = @"NotUnique";
NSString *const kAKValueHasInvalidFormatError = @"InvalidFormat";
NSString *const kAKValueHasInvalidLengthtError = @"InvalidLength";
NSString *const kAKMissingValueError = @"MissingValue";
NSString *const kAKValueIsOutOfScopeError = @"OutOfScope";

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

@implementation AKValidationError

- (NSString*)description
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ( self.key ) {
        [dict setValue:self.key forKey:@"key"];
    }
    if ( self.code ) {
        [dict setValue:self.code forKey:@"code"];
    }
    if ( self.message ) {
        [dict setValue:self.message forKey:@"message"];
    }
    return [dict description];
}

@end

///-----------------------------------------------------------------------------
///-----------------------------------------------------------------------------
///-----------------------------------------------------------------------------

@implementation AKValidationErrors
{
    NSMutableArray *_errors;
}

- (id)initWithErrors:(NSArray*)errors
{
    if ( self = [super init] ) {
        _errors = [NSMutableArray arrayWithArray:errors];
    }
    return self;
}

- (NSArray*)errorsForKey:(NSString*)key
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(AKValidationError *error in self.errors) {
        if ( [error.key isEqualToString:key] ) {
            [mutableArray addObject:error];
        }
    }
    return mutableArray;
}

- (AKValidationError*)errorForKey:(NSString*)key code:(NSString*)code
{
    AKValidationError *result = nil;
    for(AKValidationError *error in [self errorsForKey:key]) {
        if ( [error.code isEqualToString:code] ) {
            result = error;
            break;
        }
    }
    return result;
}

- (NSString*)description
{
    return [_errors description];
}

@end