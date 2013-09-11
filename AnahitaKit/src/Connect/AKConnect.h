//
//  AnahitaCoreEntity.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-11.
//
//

#import "Facebook-iOS-SDK/FacebookSDK/Facebook.h"
#import "SHOmniAuthProvider.h"
#import "AKAnahitaAPI.h"
#import "SHOmniAuthTwitter.h"
#import "SHOmniAuth.h"

/**
 @enum
 
 @abstract
*/
typedef enum {
    //facebook
    kAKFacebookServiceType,
    //twitter
    kAKTwitterServiceType
} AKConnectServiceType;

#import "AKServiceConfiguration+AKConnect.h"
#import "AKOAuthSessionCredential.h"
#import "AKPerson+Facebook.h"
