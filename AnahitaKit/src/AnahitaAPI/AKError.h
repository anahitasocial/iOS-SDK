//
//  AKError.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "RKErrorMessage.h"
#import <Foundation/Foundation.h>

/**
 @class AKError
 
 @abstract
*/
@interface AKError : RKErrorMessage

/** @abstract */
@property(nonatomic,assign) NSUInteger code;

/** @abstract */
@property(nonatomic,strong) NSArray* errors;

@end

@interface NSError(AKError)

/** @abstract */
- (BOOL)keyDidFail:(NSString*)key;

/** @abstract */
- (BOOL)key:(NSString*)key didFailWithCode:(NSString*)code;

/** @abstract */
@property(nonatomic,readonly) NSUInteger errorCode;

/** @abstract */
@property(nonatomic,readonly) NSString *errorMessage;


@end