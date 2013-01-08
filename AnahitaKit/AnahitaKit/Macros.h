//
//  Macros.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#define AnahitaCoreBundle \
        [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnahitaKitCore" ofType:@"bundle"]]

#define kAKPlusIconImage \
    [AnahitaCoreBundle pathForResource:@"31-circle-plus" ofType:@"png"]

#define kAKSocialGraphIconImage \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"112-group" ofType:@"png"]]

#define kAKNewsFeedIconImage \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"166-newspaper" ofType:@"png"]]

#define kAKLikeIconImage \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"03-heart" ofType:@"png"]]

#define kAKTwitterButtonIcon \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"twitter-button-logo" ofType:@"png"]]

#define kAKFacebookButtonIcon \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"facebook-button-logo" ofType:@"png"]]

#define kAKMapBarButtonIcon \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"103-map" ofType:@"png"]]

#define kAKDefaultAvatarImage \
    [UIImage imageWithContentsOfFile:[AnahitaCoreBundle pathForResource:@"square_default" ofType:@"gif"]]
    
#define HEXCOLOR(value) \
    [UIColor colorWithRed:(value >> 16)/255.0f green:((value & 0xff00) >> 8) /255.0f blue:(value & 0xff)/255.0f alpha:1]

