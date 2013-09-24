//
//  AKParamData.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@implementation AKParamData

+ (id)paramWithData:(NSData*)data
{
    return [self paramWithData:data fileName:nil MIMEType:@"binary/octet-stream"];
}

+ (id)paramWithData:(NSData*)data MIMEType:(NSString*)MIMEType
{
    return [self paramWithData:data fileName:nil MIMEType:MIMEType];
}

+ (id)paramWithData:(NSData*)data fileName:(NSString*)fileName MIMEType:(NSString*)MIMEType
{
    return [[self alloc] initWithData:data fileName:fileName MIMEType:MIMEType];
}

- (id)initWithData:(NSData*)data fileName:(NSString*)fileName MIMEType:(NSString*)MIMEType
{
    if ( self = [super init] ) {
        _data = data;
        _fileName = fileName;
        _MIMEType = MIMEType;
        if ( NULL == _MIMEType ) {
            _MIMEType = @"binary/octet-stream";
        }
    }
    return self;
}

@end
