//
//  NICSSRuleset+AKCSS.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-02-02.
//
//

#import "NICSSRuleset.h"

/**
 @category
 
 @abstract 
 Adds a method to return the raw ruleset
*/
@interface NICSSRuleset (AKCSS)

/** @abstract Raw Ruleset */
@property(nonatomic,readonly) NSDictionary* rules;

@end
