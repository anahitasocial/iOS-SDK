//
//  AKAnahitaAPIMethods.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "AKAnahitaAPI.h"

/**
 @method
 
 @abstract
*/
RKObjectManager* AKInitObjectManagerForAnahitaService(NSURL* serviceURL)
{
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:serviceURL];
    [objectManager.HTTPClient setDefaultHeader:@"accept"  value:@"application/json"];
    [objectManager.HTTPClient setDefaultHeader:@"referer" value:[serviceURL absoluteString]];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[AKError class]];
    [errorMapping addAttributeMappingsFromDictionary:@{
        @"message" : @"errorMessage",
        @"code"    : @"code",
        @"errors"  : @"errors"
    }];
    
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [objectManager addResponseDescriptor:errorResponseDescriptor];
    
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];

    [paginationMapping addAttributeMappingsFromDictionary:@{
        @"pagination.limit":     @"perPage",
        @"pagination.total":     @"pageCount"
    }];
    return objectManager;
}
