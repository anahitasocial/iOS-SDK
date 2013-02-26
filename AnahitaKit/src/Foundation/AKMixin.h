//
//  AKMixin.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

//#define MIXER_VAR MIXER_VAR(id);
#define MIXER_VAR(type) type mixer = (type)self;

#define ADD_BEHAVIOR_TO_CLASS(class, behavior) \
    @interface class(behavior) <behavior> @end @implementation class(behavior) @end

#define DEFINE_BEHAVIOR(behavior) \
    @protocol behavior <AKBehavior> \
    @optional

/**
 @protocol AKMixin
 
 @abstract
 Any protocol extendig the AKBehavior will be mixed
 */
@protocol AKBehavior <NSObject> @end

/**
 @protocol AKMixable
 
 @abstract
 The mixable class
 */
@protocol AKMixin <NSObject>

@optional

+ (BOOL)mixinShouldMixWithClass:(Class)class;
+ (void)mixinWillMixSelectors:(NSMutableArray*)selectors withClass:(Class)class;
+ (void)mixinDidMixSelectors:(NSMutableArray*)selectors withClass:(Class)class;

@end


/**
 @method
 
 @abstract
 This method is called once on the app startup and autoamtically mixin the behaviors
 for each class that conforms to AKBehavior protocol
 
 */
void APPLY_MIXINS();
