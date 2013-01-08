//
//  AKError.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-09.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "NSError+AKValidationError.h"

/**
 Common validation errors
 */
extern NSString *const kAKValueIsNotUniqueError;
extern NSString *const kAKValueHasInvalidFormatError;
extern NSString *const kAKValueHasInvalidLengthtError;
extern NSString *const kAKMissingValueError;
extern NSString *const kAKValueIsOutOfScopeError;

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

/**
 captures a validation error for a key
 
 */
@interface AKValidationError : NSObject

@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *message;

@end

@interface AKValidationErrors : NSObject

/**
 Intializes new instance of AKValidationErrors with an array of AKKeyValidationError
 
 @param Array of AKValidationErrors
 @return new instance
 */
- (id)initWithErrors:(NSArray*)errors;

/**
 Return an array validation errors for a key name
 
 @return array
 */
- (NSArray*)errorsForKey:(NSString*)key;

/**
 Return an error object for an error name and key
 
 @return Error object or nil
 */
- (AKValidationError*)errorForKey:(NSString*)key code:(NSString*)code;

/**
 Contains a list of errors
 */
@property(nonatomic,readonly) NSArray* errors;

@end
