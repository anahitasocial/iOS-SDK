//
//  AKAction.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.


/**
 @protocol AKActionDelegate
 
 @abstract
*/
@protocol AKViewNotificationDelegate <NSObject>

@required
/** @abstract */
- (void)view:(UIView*)view didPostNotification:(NSNotification*)aNotification;

@end
