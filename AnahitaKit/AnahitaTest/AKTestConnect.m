//
//  AKTestConnect.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-16.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKTestConnect.h"
#import "RestKit.h"
#import "GCOAuth.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "AKTwitterReverseOAuth.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AKPersonFormViewController.h"
#import <objc/runtime.h>


@implementation AKTestConnect

- (void)testLoader
{
   
    id delegate = $$(
        @selector(objectLoader:didLoadObjects:), ^(id loader, id objects) {
            AKStoryObject *story = [objects objectAtIndex:0];
            NSLog(@"%@", story.object.author);
        },
        @selector(objectLoader:didFailWithError:), ^(id loader, id error ) {
            NSLog(@"%@", error);
        }
    );
    [AKStoryObject loadCollectionWithQuery:@"oid=5&component=com_posts" delegate:delegate];
    AKThreadSleep;
    
//    [[AKPersonObject objectWithId:5] loadWithDelegate:$(
//                @selector(objectLoader:didLoadObject:), ^(id loader,id object) {
//                    NSLog(@"D");
//                },
//                @selector(objectLoader:didFailWithError:), ^(id loader, id error) {
//                
//                }
//     )];
    //[AKStoryObject loadCollectionWithQuery:@{@"component":@"com_posts",@"oid":@"5"} delegate:delegate];
    
    AKThreadSleep;
    
//    [AKStoryObject loadCollectionWithQuery:@"name[]=actor_follow" delegate:delegate];
    
   
    
//    class_addMethod(Dynamic_class, @selector(init), imp_implementationWithBlock(^(id self) {
//        return self;
//    }), "@@:");
//    class_addMethod(Dynamic_class, @selector(doSomething), imp_implementationWithBlock(^(id self) {
//        
//    }), "v@:");
    
//    AKObjectLoaderFactory *personLoader = AKPersonObject.sharedLoader;
//    AKPersonObject *person = [[AKPersonObject alloc] initWithId:5];
//    //[personLoader loaderForObject:person];
//    [personLoader loaderForObject:person withStringParams:@"get=graph&type=followers"];
    
//    AKSessionObject *session = [AKSessionObject new];
//    [session setUsername:@"asanieyan" password:@"v3j7n1"];
//    [session saveWithBlock:^(RKObjectLoader *loader) {
//        loader.onDidLoadObject = ^(id object) {
//            NSLog(@"D");
//        };
//    }];
//    AKThreadSleep;
//    RKObjectLoader *loader = [AKPersonObject.sharedLoader loaderForObject:[AKPersonObject objectWithId:5]];
//    loader.onDidLoadObjects = ^(id objects) {
//        NSLog(@"D%@",objects);
//    };
//    loader.onDidLoadObject = ^(id object) {
//        NSLog(@"D%@",object);
//    };
//    loader.onDidLoadResponse = ^(RKResponse *response) {
//        NSLog(@"%@", response.bodyAsString);
//    };
//    [loader send];
    
//    AKPersonObject *person = [AKPersonObject objectWithId:5];
//    [person followersWithBlock:^(RKObjectLoader *loader) {
//        loader.onDidLoadObjects = ^(id objects) {
//            NSLog(@"%@", objects);
//        };
//    }];
    
//    AKThreadSleep;
    
}

- (void)atestFacebook
{
    NIDPRINT(@"D");
    
    FBSession *session = [[FBSession alloc] initWithAppID:@"131488453564721" permissions:nil urlSchemeSuffix:@"" tokenCacheStrategy:nil];
    
    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"");
    }];
    AKThreadSleep;
    
}

- (void)t2estTwitter
{
    
//    NSString *key = @"YZD9OFU5ZyAkJ9f3HtExtw";
//    NSString *secret = @"HJfXcErf4ikkHNNLx2CFpqrURqyhsjY2A4CvJfId93c";
//    id mock = [OCMockObject mockForProtocol:@protocol(AKTwitterReverseOAuthDelegate)];
//    AKTwitterReverseOAuth *reverseOAuth = [[AKTwitterReverseOAuth alloc] initWithConsumerKey:key consumerSecret:secret];
//    [[[mock expect] andDo:^(NSInvocation *invocation) {
//        AKThreadResume;
//    }] twitterReverseOAuth:reverseOAuth didSucceedWithToken:[OCMArg any] secret:[OCMArg any] info:[OCMArg any]];
//    reverseOAuth.delegate = mock;
//    [reverseOAuth reverseAuthenticate];
//    AKThreadSleep;
//    
//    AKSessionObject *session = [AKSessionObject sessionWithOAuthToken:reverseOAuth.oauthToken OAuthSecret:reverseOAuth.oauthSecret OAuthService:@"twitter"];
//    NSLog(@"%@", session);
////    [session saveWithBlock:^(RKObjectLoader *loader) {
////        loader.onDidLoadResponse = ^(RKResponse *response) {
////            NSLog(@"%@", response.bodyAsString);
////        };
////    }];
//    STAssertTrue([session save],@"should have saved");
////    AKThreadSleep;
}

@end
