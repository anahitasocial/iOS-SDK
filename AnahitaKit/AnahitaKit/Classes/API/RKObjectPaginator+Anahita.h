//
//  RKObjectPaginator+Anahita.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RKObjectPaginator.h"


@interface RKObjectPaginator()

/** @abstract object mapping to use for pagination */
@property(nonatomic,strong) RKObjectMapping *objectMapping;

/** @abstract check if a paginator is in the middle of a load */
@property(nonatomic,readonly, getter = isLoading) BOOL loading;

@end
