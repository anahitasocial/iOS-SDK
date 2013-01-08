//
//  TestSetup.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-16.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "TestSetup.h"

__attribute__((constructor))
static void initialize() {
    AKMixinAllClassesBehaviors();
//    AKGlobalConfiguration.sharedInstance.siteURL = [NSURL URLWithString:@"http://localhost/anahita/branches/search/site"];
    //TestObjectManager;
}