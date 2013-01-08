//
//  AKTestPerson.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-08.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKTestPerson.h"
#import "RestKit.h"

@implementation AKTestPerson

- (void)testSavePerson
{
    AKSessionObject *session = [AKSessionObject objectWithValues:@{@"username":@"asanieyan",@"password":@"v3j7n1"}];
    STAssertTrue([session save], @"Login didn't succeed");
    
    AKPersonObject *person = [[AKPersonObject alloc] initWithId:1];
    //lets load the person
    [person load];

    person.name = @"arash sanieyan2";
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"avatar" ofType:@"jpg"];
    NSData *data   = [NSData dataWithContentsOfFile:path];
    [person setPortraitImageData:data];
    NSError *error;
    BOOL result = [person save:&error];
    STAssertTrue(result, @"should have saved %@", error);
}

- (void)testLoadPerson
{
    AKPersonObject *person = [[AKPersonObject alloc] initWithId:5];
    [person load];
    
    NSLog(@"%@", person);
}

@end
