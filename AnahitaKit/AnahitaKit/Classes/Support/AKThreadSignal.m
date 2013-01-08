//
//  AKThreadPause.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKThreadSignal.h"

static NSMutableDictionary *_runLoopConditions;

@implementation AKNonBlockThreadStopper
{
    BOOL _wait;
}

+ (void)waitUntilBlockReturnsTrue:(BOOL(^)())block;
{
    while (!block()) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

+ (BOOL)waitUntilBlockReturnsTrue:(BOOL (^)())condition orTimeoutIn:(int)seconds
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

+ (id)stopperForThread:(NSThread*)thread
{
    //get the current runloop
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _runLoopConditions = [NSMutableDictionary dictionary];
    });
    
    NSString *threadId = [NSString stringWithFormat:@"%@", thread];
    
    if ( ![_runLoopConditions valueForKey:threadId] ) {
        [_runLoopConditions setObject:[AKNonBlockThreadStopper new] forKey:threadId];
    }
    return [_runLoopConditions objectForKey:threadId];
}

+ (id)stopperForMainThread
{
    return [self stopperForThread:[NSThread mainThread]];
}

+ (id)stopperForCurrentThread
{
    return [self stopperForThread:[NSThread currentThread]];
}

- (id)init
{
    if ( self = [super init] ) {
        _wait = NO;
    }
    return self;
}

- (void)wait
{
    if ( _wait == NO ) {
        _wait = YES;
        [AKNonBlockThreadStopper waitUntilBlockReturnsTrue:^BOOL{
            return NO == _wait;
        }];
    }
}

- (void)waitWithTimeout:(int)seconds
{
    if ( _wait == NO ) {
        _wait = YES;
        [AKNonBlockThreadStopper waitUntilBlockReturnsTrue:^BOOL{
            return NO == _wait;
        } orTimeoutIn:seconds];
    }
}

- (void)resume
{
    _wait = NO;
}

@end