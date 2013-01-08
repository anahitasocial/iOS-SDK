//
//  NSError+AKKeyValidationError.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-10.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "RestKit.h"
#import <objc/runtime.h>

///-----------------------------------------------------------------------------
/// Internal constants
///-----------------------------------------------------------------------------

NSString *const kAKValiationErrorDomain = @"com.anahita.AnahitaKit.ValidationErrorDomain";
NSString *const kAKValidationErrorsKey  = @"kAKValidationErrorsKey";

#define kBridgedAKValidationErrorsKey (__bridge void *)kAKValidationErrorsKey

@implementation NSError(AKValidationError)

+ (id)validationErrorWithKey:(NSString*)key code:(NSString*)code
{
    return [self validationErrorWithKey:key code:code
                                message:@""];
}

+ (id)validationErrorWithKey:(NSString*)key code:(NSString*)code message:(NSString*)message
{
    AKValidationError *error = [AKValidationError new];
    
    error.key  = key;
    error.code = code;
    
    AKValidationErrors *errors = [[AKValidationErrors alloc] initWithErrors:[NSArray arrayWithObject:error]];
    
    return [NSError errorWithDomain:kAKValiationErrorDomain code:100
                           userInfo:@{kAKValidationErrorsKey : errors}];
}

- (AKValidationErrors*)validationErrors
{
    //if it has the validation errors then just return it
    if ( [self.userInfo valueForKey:kAKValidationErrorsKey] ) {
        return [self.userInfo valueForKey:kAKValidationErrorsKey];
    }
    
    if ( objc_getAssociatedObject(self,kBridgedAKValidationErrorsKey) ) {
        return objc_getAssociatedObject(self, kBridgedAKValidationErrorsKey);
    }
    
    //lets check the object mapper
    if ( [self.userInfo valueForKey:RKObjectMapperErrorObjectsKey] )
    {
        id errors = [self.userInfo valueForKey:RKObjectMapperErrorObjectsKey];
        
        if ( errors != NULL ) {
            errors = [[AKValidationErrors alloc] initWithErrors:errors];
            objc_setAssociatedObject(self, kBridgedAKValidationErrorsKey, errors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return errors;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    objc_setAssociatedObject(self, kBridgedAKValidationErrorsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)validationDidFailWithCode:(NSString*)code
{
    if ( [self validationDidFail] ) {
        for(AKValidationError *error in [self validationErrors].errors) {
            if ( [error.code isEqualToString:code] ) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)validationDidFailForKey:(NSString*)key codes:(NSArray*)codes
{
    BOOL failed = NO;
    for(NSString* code in codes) {
        if ( [self validationDidFailForKey:key code:code] ) {
            failed = YES;
            break;
        }
    }
    return failed;
}

- (BOOL)validationDidFailForKey:(NSString*)key code:(NSString*)code
{
    return [self validationDidFail] && [[self validationErrors] errorForKey:key code:code] != nil;
}

- (BOOL)validationDidFail
{
    return [self validationErrors] != nil;
}


@end
