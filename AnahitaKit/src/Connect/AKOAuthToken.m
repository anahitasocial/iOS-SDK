//
//  AKOAuthToken.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@implementation AKOAuthToken : NSObject

- (id)initWithKey:(NSString*)aKey secret:(NSString*)aSecret;
{
    if ( self = [super init] ) {
        _key     = aKey;
        _secret  = aSecret;
    }
    return self;
}

@end