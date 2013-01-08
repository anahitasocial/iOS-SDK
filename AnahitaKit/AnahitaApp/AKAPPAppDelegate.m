//
//  AKAPPAppDelegate.m
//  AnahitaApp
//
//  Created by Arash  Sanieyan on 2012-10-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKAPPAppDelegate.h"
#import "RKObjectManager.h"
#import "AnahitaKit.h"
#import "Hive.h"
#import <FacebookSDK/FacebookSDK.h>
#import "JASidePanelController.h"

#define DEBUG 1

@interface AKAPPAppDelegate(Private) <AKLoginViewControllerDelegate, AKSessionObjectDelegate>

@end

@implementation AKAPPAppDelegate
{
    AKSessionObject *_session;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //set object manager
    NSString *sitePath = @"http://hive.peerglobe.com/";
//    sitePath = @"http://localhost/anahita/branches/search/site";
    
    AKGlobalConfiguration.sharedInstance.siteURL = [NSURL URLWithString:sitePath];
    

    [AKGlobalConfiguration.sharedInstance addOAuthConsumer:
         [AKOAuthConsumer consumerForService:@"facebook" key:@"456835081039936" secret:@"450fec0dd9bdcc55ed5d8a3354b12c53"]
    ];
    
    [AKGlobalConfiguration.sharedInstance addOAuthConsumer:
         [AKOAuthConsumer consumerForService:@"twitter" key:@"NrywHQQEqssEIFh8aawMg" secret:@"FhqfwLtbF9rqWWaQGq3qWljz0BnPzgjfxK6VC7pF8"]
     ];
    
    _session = [AKSessionObject new];
    _session.delegate = self;
    [_session login];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ( nil != FBSession.activeSession ) {
        [FBSession.activeSession handleOpenURL:url];
    }
    return YES;
}

#pragma mark AKSessionObjectDelegate

- (void)sessionObject:(AKSessionObject *)sessionObject didAuthenticatePerson:(AKPersonObject *)person
{
    [self startApplication];
}

- (void)sessionObject:(AKSessionObject *)sessionObject didFailAuthenticationWithError:(AKSessionAuthenticationError)error
{
    [self showLoginView];
}

#pragma mark AKUILoginControllerDelegate

- (void)loginController:(AKLoginViewController *)loginController didLoginPerson:(AKPersonObject *)person
{
    [self startApplication];
}

- (void)startApplication
{
    AKNavigationViewController *navController = [AKNavigationViewController new];
    
    AKPersonObject *person = [AKSessionObject viewer];
    
    [navController addNavigationItem:
         [AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
            instance.controller = [AKActorDetailViewController detailViewControllerForActor:person];
            instance.title = person.name;
            instance.iconImageURL = [person.imageURL imageURLWithImageSize:kAKSquareImageURL];
        }]
    ];

    [navController addNavigationItem:[AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
        AKStoryListViewController *storyController = [AKStoryListViewController new];
        storyController.storyQuery.names = @[@"post_add",@"flyer_add"];
        instance.controller = storyController;
        instance.title = @"News Feed";
    }]];
    
    [navController addNavigationItem:[AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
        AKActorListViewController *listController = [ComBarsBarListViewController new];
        listController.objectPaginator = [ComBarsBar paginatorWithQuery:nil];
        instance.controller = listController;
        instance.title = @"Bars";
    }]];
    
    [navController addNavigationItem:[AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
        RKObjectLoader *loader = [ComCampusesCampuse loaderWithQuery:nil];
        ComCampusesListViewController *listController = [ComCampusesListViewController new];
        listController.objectLoader = loader;
        instance.controller = listController;
        instance.title = @"Schools";
    }]];    
    
    [navController addNavigationItem:[AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
        AKPersonFormViewController *formController = [AKPersonFormViewController new];
        formController.personObject = person;
        instance.controller = formController;
        instance.title = @"Edit Profile";
    }]];
    
    [navController addNavigationItem:[AKNavigationItem instantiateUsingBlock:^(AKNavigationItem* instance) {
        instance.onSelect = ^() {
            [self showLoginView];
        };
        instance.title = @"Logout";
    }]];
    
    navController.selectedIndex = 1;
    JASidePanelController *viewController = [JASidePanelController new];
    viewController.leftPanel  = navController;
    viewController.centerPanel= navController.contentController;
    if ( self.window.rootViewController ) {
        [self.window.rootViewController.view removeFromSuperview];
    }
    _window.rootViewController = viewController; 
}

- (void)showLoginView
{
    //show the login page
    AKLoginViewController *loginController = [AKLoginViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    loginController.delegate = self;
    if ( self.window.rootViewController ) {
        [self.window.rootViewController.view removeFromSuperview];
    }
    self.window.rootViewController = navController;
    [self.window addSubview:navController.view];    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
