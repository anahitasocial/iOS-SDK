//
//  AKEntityProtocols.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class CLLocation;
@class AKImageURLs;
@class AKProfileViewController;

@protocol AKEntityHasProfileView <NSObject>

- (AKProfileViewController*)profileViewController;

@end

//loctable behavior
@protocol AKEntityLocatable <NSObject>

- (CLLocation*)location;

@end

//describable behavior
@protocol AKEntityDescribable <NSObject>

- (NSString*)name;
- (NSString*)body;

@end

//portiable behavior
@protocol AKEntityPortriable <NSObject>

- (AKImageURLs*)imageURLs;

@end

@protocol AKActorEntityFollowable <NSObject>

- (NSUInteger)followerCount;

@end

@protocol AKActorEntityLeadeable <NSObject>

- (NSUInteger)leadersCount;
- (NSUInteger)mutualCount;

@end