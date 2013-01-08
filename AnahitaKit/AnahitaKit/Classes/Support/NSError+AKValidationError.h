//
//  NSError+AKKeyValidationError.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-10.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKValidationErrors;

/**
 Adds method to the NSError to extract validation errors within an NSError object
 
 */
@interface NSError(AKValidationError)

/**
 Creates a validation error
 */
+ (id)validationErrorWithKey:(NSString*)key code:(NSString*)code;
+ (id)validationErrorWithKey:(NSString*)key code:(NSString*)code message:(NSString*)message;

/**
 by returning true then an operation has failed because some data validation has
 failed
 
 @return whether the validation has failed or not
 */
- (BOOL)validationDidFail;

/**
 Check if an error exists for a key
 
 @return True if found an error for a key otherwise false
 */
- (BOOL)validationDidFailForKey:(NSString*)key code:(NSString*)code;

/**
 Check if a list of errors exists for a key
 
 @return True if found an error for a key otherwise false
 */
- (BOOL)validationDidFailForKey:(NSString*)key codes:(NSArray*)codes;

/**
 Check if a validation failed with a code
 
 @return True if found an error for a key otherwise false
 */
- (BOOL)validationDidFailWithCode:(NSString*)code;

/**
 If the error is caused by some kind of validation failure this array will
 return an AKValidationErrors or null
 
 @return AKValidationErrors or null
 */
- (AKValidationErrors*)validationErrors;

@end

