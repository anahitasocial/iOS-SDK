//
//  AKServiceConfiguration.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKAnahitaAPI.h"

@implementation AKServiceConfiguration

+ (id)sharedConiguration
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       sharedInstance = [self new];
    });
    return sharedInstance;    
}

- (void)setServiceURL:(NSURL *)serviceURL
{
    _serviceURL = serviceURL;
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:_serviceURL];
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
}

@end
