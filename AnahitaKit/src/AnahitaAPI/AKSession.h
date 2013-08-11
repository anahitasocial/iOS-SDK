//
//  AKSession.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import <Foundation/Foundation.h>

@class AKPerson;

@protocol AKSessionCredential <NSObject>

@required

- (NSDictionary*)toParameters;

@end

@interface NSDictionary(AKSessionCredential) <AKSessionCredential>

@end

@interface AKSessionBasicAuthCredential : NSObject <AKSessionCredential>

- (id)initWithUsername:(NSString*)username andPassword:(NSString*)password;

@end

@interface AKSession : NSObject

/**
 @method 
 
 @abstract
 Return a singleton session object. Tries to login the user using the
 existing username and pasword
*/
+ (instancetype)sessionWithCredential:(id<AKSessionCredential>)credential;

/**
 @method 
 
 @abstract
 Return a singleton session object. Tries to login the user using the
 existing username and pasword
*/
+ (instancetype)sharedSession;

/**
 @method 
 
 @abstract
 Logs in the username and password. Store the session
 posts a notification for the below scenarios
*/
- (id)initWithCredential:(id<AKSessionCredential>)credential;

/**
 @method 
 
 @abstract
 Logs in the username and password. Store the session
 posts a notification for the below scenarios
*/
- (void)login:(void(^)(AKPerson *viewer))success failure:(void(^)(NSError *error))failure;

/**
 @method 
 
 @abstract
 Logs in the username and password. Store the session
 posts a notification for the below scenarios
*/
- (void)login;

/**
 @method
 
 @abstract 
 Logs out a sesssion
*/
- (void)logout;

/** @abstract */
@property (nonatomic,readonly,getter=isValid) BOOL valid;

/** @abstract */
@property (nonatomic,strong,readonly) id<AKSessionCredential> credential;

/** @abstract */
@property (nonatomic,strong,readonly) AKPerson* viewer;

@end

/**
 Notifications
*/
extern NSString *const kAKSessionDidLogin;
extern NSString *const kAKSessionDidFailLogin;
extern NSString *const kAKSessionDidLogout;

/**
 Notifications
*/
extern NSString *const kAKSessionViewerNotificationKey;
