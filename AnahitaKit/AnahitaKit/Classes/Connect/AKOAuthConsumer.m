//
//  AKOAuthConsumer.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-23.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKOAuthConsumer.h"

@implementation AKOAuthConsumer

+ (id)consumerForService:(NSString *)service key:(NSString *)aKey secret:(NSString *)aSecret
{
    return [[self alloc] initWithService:service key:aKey secret:aSecret];
}

- (id)initWithService:(NSString *)service key:(NSString *)aKey secret:(NSString *)aSecret
{
    if ( self = [super init] ) {
        _key     = aKey;
        _secret  = aSecret;
        _service = service;
    }
    return self;
}

@end

