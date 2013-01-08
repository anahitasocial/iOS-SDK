//
//  AKTestEntity.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "AKTestEntity.h"
#import "RestKit.h"
#import <objc/runtime.h>

@interface Person : NSObject

@property(nonatomic,strong) NSNumber *identifier;

@end
@implementation Person

@end

@implementation AKTestEntity

- (void)test1
{
//    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Person class]];
//    [mapping addAttributeMappingsFromDictionary:@{@"id":@"identifier"}];
//    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/people/person/:identifier" keyPath:@"" statusCodes:nil];
//
////    NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
////    [RKObjectRequestOperation al
//    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost/anahita/branches/search/site/index.php/"]];
//    
//    Person *person = [Person new];
//    [manager router]
//    person.identifier = [NSNumber numberWithInt:1];
//    [manager addResponseDescriptor:descriptor];    
//    NSMutableURLRequest *request = [manager requestWithObject:person method:RKRequestMethodGET path:nil parameters:nil];
//    NSLog(@"%@", request);
//    
//    NSLog(@"D");
}

@end
/*
@implementation AKTestEntity

- (void)setUp
{
    AKMixinAllClassesBehaviors();
    TestObjectManager;
}

- (void)testBehavior
{
    __block BOOL success = NO;
    
    AKPerson *person1, *person2;

    person1 = [[AKPerson alloc] initWithId:1];
    person2 = [[AKPerson alloc] initWithId:5];
    


    [person2 addFollower:person1 block:^(RKObjectLoader *loader) {        
        loader.onDidLoadResponse = ^(RKResponse *response) {
            STAssertTrue([response statusCode] == 205, @"The success code should have been 205");
            success = YES;
        };
    }];
    
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:10], @"Should have succeeded");
    success = NO;
    [person2 loadWithBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            success = YES;
        };
    }];
    
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:10], @"Should have succeeded");

    STAssertTrue([person2.commands containsCommandWithName:AKUnfollowActorCommand], @"should have contained unfollow");

    success = NO;
    
    [person2 deleteFollower:person1 block:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            STAssertTrue([response statusCode] == 205, @"The success code should have been 205");
            success = YES;
        };
    }];
   
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:10], @"Should have succeeded");
    
    success = NO;
    
    [person2 loadWithBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            NSLog(@"%@", response.bodyAsString);
            success = YES;
        };
    }];
    
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:10], @"Should have succeeded");
    
    STAssertTrue([person2.commands containsCommandWithName:AKFollowActorCommand], @"should have contained follow");
    
}

- (void)testList
{
    __block BOOL success = NO;
    [[AKPerson sharedRepository] loadListWithQueryDictionary:[NSDictionary dictionaryWithObject:@"mark" forKey:@"q"] loader:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray* objects) {
            for(AKPerson *person in objects) {
                NSLog(@"%@", person.name);
            }
            success = [objects count] > 0;
        };
        loader.onDidLoadResponse = ^(RKResponse *response) {
             NSLog(@"%@", response);
        };
    }];
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:3], @"Should have succeeded");
    
}

- (void)testEntityRouter
{
    AKObjectResource *resource = [[AKObjectResource alloc] initWithObjectClass:[AKPerson class]];    
    AKObjectResourceRouter *router = [[AKObjectResourceRouter alloc] initWithObjectResource:resource];
    
    STAssertTrue([@"/people/person" isEqualToString:router.resourcePath],@"Should be the same");
    STAssertTrue([@"/people/people" isEqualToString:router.resourcesPath],@"Should be the same");
    NSString *path = [router resourcesPathWithQueryDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"foo",@"q", nil]];
    STAssertTrue([@"/people/people?q=foo" isEqualToString:path],@"Should be the same");
}

- (void)testEntityRepository
{
    AKObjectRepository *repos =[AKPerson sharedRepository];
    
    __block BOOL success = NO;
    
    [repos loadWithId:5 loader:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(AKPerson *person) {
            NSLog(@"%@", person.name);
            success = YES;
        };
        loader.onDidLoadResponse = ^(RKResponse *response) {
            NSLog(@"%@", response);
        };
    }];
    
    STAssertTrue([[AKThreadSignal sharedInstance] waitForBoolSignal:&success for:10], @"Should have succeeded");
}

@end
*/