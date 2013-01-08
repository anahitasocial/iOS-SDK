//
//  AKAttributedLabel.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "NIAttributedLabel.h"

/**
 @class NSTextCheckingResult
 
 @abstract
 Adds a new property object that represent an object found within a selection
*/
@interface NSTextCheckingResult()

/** @abstract The object found within a result */
@property (readonly) id object;

@end

/**
 @method
 
 @abstract
 Returns a link tag that can be used within a AKAttributedLabel. If this link tag is
 touched, the delegate method will be called
*/
NSString* AKLinkTagFromObject(id object, NSString* text);

/**
 @class AKAttributedLabel
 
 @abstract
 Extends the NIAttributedLabel to provide support for basic HTML parsing
  
*/
@interface AKAttributedLabel : NIAttributedLabel

@end


