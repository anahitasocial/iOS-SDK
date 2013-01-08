//
//  AKThreadPause.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKNonBlockThreadStopper : NSObject

+ (id)stopperForThread:(NSThread*)thread;
+ (id)stopperForMainThread;
+ (id)stopperForCurrentThread;
- (void)wait;
- (void)waitWithTimeout:(int)seconds;
- (void)resume;

@end

#define AKThreadSleep  [[AKNonBlockThreadStopper stopperForCurrentThread] wait];
#define AKThreadResume [[AKNonBlockThreadStopper stopperForCurrentThread] resume];
#define AKMainThreadSleep [[AKNonBlockThreadStopper stopperForMainThread] wait];
#define AKMainThreadResume [[AKNonBlockThreadStopper stopperForMainThread] resume];
