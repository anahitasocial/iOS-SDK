//
//  AKConfiguration.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-20.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

static AKGlobalConfiguration *sharedInstance;

@implementation AKGlobalConfiguration
{
    RKObjectManager *_objectManager;
    NSMutableArray *_oAuthsConsumers;
}

@synthesize siteURL = _siteURL;

+ (AKGlobalConfiguration*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AKGlobalConfiguration new];
    });
    return sharedInstance;
}

+ (void)setSharedInstance:(id)sharedInstance
{
    sharedInstance = sharedInstance;
}

- (id)init
{
    if ( self = [super init] ) {
        _oAuthsConsumers = [NSMutableArray array];
    }
    
    return self;
}

- (void)setSiteURL:(NSURL *)siteURL
{
    _siteURL = siteURL;
    NSString *path   = [[self.siteURL absoluteString] stringByAppendingString:@"/index.php/"];
    //set the base url of the object manager

    _objectManager.client = [RKClient clientWithBaseURLString:path];
    _objectManager.acceptMIMEType = RKMIMETypeJSON;
}

- (RKObjectManager*)objectManager
{
    if ( NULL == _objectManager ) {
        _objectManager = [[RKObjectManager alloc] init];
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[AKValidationError class]];
        mapping.rootKeyPath = @"errors";
        [mapping mapAttributes:@"code",@"key",@"message", nil];
        [_objectManager.mappingProvider setErrorMapping:mapping];
        mapping = [RKObjectMapping mappingForClass:[RKObjectPaginator class]];
        [mapping mapKeyPath:@"pagination.limit" toAttribute:@"perPage"];
        [mapping mapKeyPath:@"pagination.total" toAttribute:@"objectCount"];
        [_objectManager.mappingProvider setPaginationMapping:mapping];
        RKLogConfigureByName("RestKit/Network/Reachability", RKLogLevelCritical);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelCritical);
        RKLogConfigureByName("RestKit/Network", RKLogLevelCritical);
    }
    
    return _objectManager;
}

- (void)addOAuthConsumer:(id)consumer
{
    [_oAuthsConsumers addObject:consumer];
}

- (NSArray*)oAuthsConsumers
{
    return (NSArray*)_oAuthsConsumers;
}

- (id)oAuthConsumerForService:(NSString*)service
{
    __block id consumer = nil;
    [_oAuthsConsumers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [[obj valueForKey:@"service"] isEqualToString:service]) {
            consumer = obj;
        }
    }];
    return consumer;
}

@end
