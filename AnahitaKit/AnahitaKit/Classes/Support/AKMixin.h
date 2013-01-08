//
//  AKMixin.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#define MIXER_VAR MIXER_VAR(id);
#define MIXER_VAR(type) type mixer = (type)self;

/**
 @protocol AKMixin
 
 @abstract
 Any protocol extendig the AKMixin will be mixed
 */
@protocol AKMixin <NSObject> @end

/**
 @method
 
 @abstract
 This method is called once on the app startup and autoamtically mixin the behaviors
 for each class that conforms to AKBehavior protocol
 
 */
void __APPLY_MIXINS();
