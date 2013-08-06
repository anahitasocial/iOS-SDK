//
//  AKParamData.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKParamData
 
 @abstract
 Data wrapper for a HTTP param
 */
@interface AKParamData : NSObject

/**
 @method
 
 @abstract
 Initializes a param object
 */
+ (id)paramWithData:(NSData*)data;

/**
 @method
 
 @abstract
 Initializes a param object
 */
+ (id)paramWithData:(NSData*)data MIMEType:(NSString*)MIMEType;

/**
 @method
 
 @abstract
 Initializes a param object
 */
+ (id)paramWithData:(NSData*)data fileName:(NSString*)fileName MIMEType:(NSString*)MIMEType;

/**
 @method
 
 @abstract
 Initializes a param
 */
- (id)initWithData:(NSData*)data fileName:(NSString*)fileName MIMEType:(NSString*)MIMEType;

/** @abstract data */
@property(nonatomic,readonly) NSData *data;

/** @abstract mimetype of the data. By default its binary/octet-stream */
@property(nonatomic,readonly) NSString *MIMEType;

/** @abstract filename of the data */
@property(nonatomic,readonly) NSString *fileName;

@end