//
//  AKThreadPause.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKThreadSignal.h"

@implementation AKThreadSignal
{
    BOOL _wait;
}

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)waitUntilBlockReturnTrue:(BOOL(^)())block;
{
    while (!block()) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)waitForBoolSignal:(BOOL *)signal
{
    [self waitForBoolSignal:signal for:INT_MAX];
}

- (void)waitForBlockSignal:(BOOL (^)())block
{
    [self waitForBlockSignal:block for:INT_MAX];
}

- (BOOL)waitForBoolSignal:(BOOL *)signal for:(int)seconds
{
    return [self waitForBlockSignal:^BOOL{
        return *signal == YES;
    } for:seconds];
}

- (BOOL)waitForBlockSignal:(BOOL (^)())condition for:(int)seconds
{
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:seconds];
    while (!condition())
    {        
        NSDate *next = [NSDate dateWithTimeIntervalSinceNow:0.1];
        if ( [next compare:timeout] == NSOrderedDescending) {
            return false;
        }
        //run the loop for 0.1 but still handle events
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, NO);
//        NSLog(@"run loop result %d", result);
    }
    return true;
}


@end
