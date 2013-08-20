//
//  AKOAuthSessionCredential.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-14.
//
//

#import "AKConnect.h"

@interface AKOAuthSessionCredential : NSObject <AKSessionCredential>

/**
 @method
 
 @abstract
*/
+ (instancetype)credentialWithToken:(NSString*)token
        secret:(NSString*)secret
        serivce:(AKConnectServiceType)service;

/** @abstract */
@property(nonatomic,readonly,copy) NSString* token;

/** @abstract */
@property(nonatomic,readonly,copy) NSString* secret;

/** @abstract */
@property(nonatomic,readonly,assign) AKConnectServiceType serviceType;

@end
