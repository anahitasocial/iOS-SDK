//
//  AKError.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "AKAnahitaAPI.h"
#import <objc/runtime.h>

@implementation AKError

@end

@implementation NSError(AKError)

SYNTHESIZE_PROPERTY_STRONG(AKError*, _setErrorObject, _errorObject);

- (AKError*)errorObject
{
    if ( ![self _errorObject] )
    {
        id object = [[self userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
        AKError *errorObject = nil;
        if ( [object isKindOfClass:[NSArray class]] &&
            [object count] > 0 ) {
            errorObject = [object objectAtIndex:0];
        } else {
            errorObject = [AKError new];
        }
        
        if ( errorObject.errors == nil ) {
            errorObject.errors = [NSArray array];
        }
    
        [self _setErrorObject:errorObject];
    }
    
    return [self _errorObject];
}

- (BOOL)keyDidFail:(NSString*)key
{
    __block BOOL result = NO;
    [[self errorObject].errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [[obj valueForKey:@"key"] isEqualToString:key] ) {
            *stop   = YES;
            result = YES;
        }
    }];
    return result;
}

- (BOOL)key:(NSString*)key didFailWithCode:(NSString*)code
{
    __block BOOL result = NO;
    [[self errorObject].errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [[obj valueForKey:@"key"] isEqualToString:key] &&
             [[obj valueForKey:@"code"] isEqualToString:code] ) {
            *stop   = YES;
            result = YES;
        }
    }];
    return result;
}

- (NSUInteger)errorCode
{
    return [self errorObject].code;
}

- (NSString*)errorMessage
{
    return [self errorObject].errorMessage;
}

@end
