//
//  AnahitaTest.m
//  AnahitaTest
//
//  Created by Arash  Sanieyan on 2012-10-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKTestAuthentication.h"
#import "Testing.h"
#import "OCMock/OCMock.h"
#import "AKPerson.h"

@interface AKTestAuthentication(Private) <AKAuthenticationDelegate>

@end

@implementation AKTestAuthentication
{
    AKThreadSignal *_pause;
}

- (void)setUp
{
    _pause = [AKThreadSignal sharedInstance];
//    RKLogConfigureByName("RestKit", RKLogLevelTrace)
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace)
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace)
    
    [super setUp];
    // Set-up code here.
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSessionStart
{
    __block BOOL success = NO;
    
    AKSession *session = [AKSession sessionWithBaseURL:[NSURL URLWithString:@"http://localhost/anahita/branches/search/site/index.php/component"]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AKSessionReadyNotification object:session queue:nil usingBlock:^(NSNotification *note) {
        STAssertTrue(session == note.object, @"session and note object should be the same");
        STAssertTrue(session.viewer != nil, @"viewer should not nil");
        success = YES;
    }];

    [session start];
    
    STAssertTrue([_pause waitForBoolSignal:&success for:3], @"session should have been true");
    
    success = false;
    
    //delete all the cookies
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:session.objectManager.baseURL];
    for(NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    session = [AKSession sessionWithBaseURL:[NSURL URLWithString:@"http://localhost/anahita/branches/search/site/index.php/component"]];

    [[NSNotificationCenter defaultCenter] addObserverForName:AKSessionErrorNotification object:session queue:nil usingBlock:^(NSNotification *note) {
        STAssertTrue(session == note.object, @"session and note object should be the same");
        STAssertTrue(session.viewer == nil, @"viewer should be nil");
        success = YES;
    }];
    
    [session start];
    
    STAssertTrue([_pause waitForBoolSignal:&success for:3], @"session should have been false");
}

- (void)testSession
{
 
    __block BOOL authenticationDidSucceed = NO;
    __block id mock = [OCMockObject mockForProtocol:@protocol(AKAuthenticationDelegate)];
    
    [[[mock stub] andDo:^(NSInvocation *invoke) {
        authenticationDidSucceed = YES;
    }] authenticationCredentialDidPass:[OCMArg any]];
    
    AKSession *session = [AKSession sessionWithBaseURL:[NSURL URLWithString:@"http://localhost/anahita/branches/search/site/index.php/component"]];
    
    STAssertFalse(session.authenticated, @"Session should not be authenticated at this time");
    session.authentication.delegate = mock;
    [session.authentication authenticateCredential:[AKAuthenticationCredential credentialWithUsername:@"asanieyan" password:@"v3j7n1"]];        
    [_pause waitForBoolSignal:&authenticationDidSucceed for:3];
    STAssertTrue(session.authenticated, @"Session should have been authenticated");
}

- (void)testAuthentication
{
    __block BOOL authenticationDidSucceed = NO;
    __block id mock = [OCMockObject mockForProtocol:@protocol(AKAuthenticationDelegate)];

    [[[mock stub] andDo:^(NSInvocation *invoke) {
        authenticationDidSucceed = YES;
    }] authenticationCredentialDidPass:[OCMArg any]];

    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://localhost/anahita/branches/search/site/index.php/component"];
    RKObjectManager *manager = [[RKObjectManager alloc] initWithBaseURL:baseURL];
    
    AKAuthentication *authentication = [[AKAuthentication alloc] initWithObjectManager:manager];
    authentication.delegate = mock;
    [authentication authenticateCredential:[AKAuthenticationCredential credentialWithUsername:@"asanieyan" password:@"v3j7n1"]];
    
    [_pause waitForBoolSignal:&authenticationDidSucceed for:3];
    
    STAssertTrue(authenticationDidSucceed,@"Authentication should have succeeded");
}



@end
