//
//  AKThreadPause.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Thread pause is a utility function that allows pausing the current 
 thread until further notice
 */
@interface AKThreadSignal : NSObject

/**
 Create and return a singelton @link AKThreadPause
 
 @return instace of of thread pause
 */
+ (id)sharedInstance;

/**
 wait for a boolean value to becomes true
 
 @param singal Boolean signal to check. This value should be passed by reference
 */
- (void)waitForBoolSignal:(BOOL*)signal;

/**
 wait for a boolean value to becomes true
 
 @param singal Boolean signal to check. This value should be passed by reference
 @return If a timeout happens return false
 */
- (BOOL)waitForBoolSignal:(BOOL*)signal for:(int)seconds;

/**
 Wait until the block call returns true
 
 @param block The block to call
 */
- (void)waitForBlockSignal:(BOOL(^)())block;

/**
  Wait until the block call returns true or a timeout occurs
 
  @param block The block to call
  @return If a timeout happens return false
 */
- (BOOL)waitForBlockSignal:(BOOL(^)())block for:(int)seconds;

@end
