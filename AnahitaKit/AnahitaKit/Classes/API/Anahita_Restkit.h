//
//  Anahita_Restkit.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class RKObjectLoader;

typedef void(^RKObjectLoaderBlock)(RKObjectLoader *loader);

typedef void(^AKOnSuccessBlock)();
typedef void(^AKOnFailureBlock)(NSError* error);

#import "AKObjectMapping.h"
#import "AKEntityConfiguration.h"
#import "AKParamData.h"
#import "AKEntityObject.h"
#import "AKEntityObjectDelegateProxy.h"
#import "RKObjectPaginator+Anahita.h"