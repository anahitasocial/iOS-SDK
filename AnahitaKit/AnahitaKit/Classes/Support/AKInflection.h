//
//  AKInflection.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 AKInflection can be used for pluralizing and singularizing NSString objects
 The inflection uses regular expression rules. New inflection rules can be added.
 
 */
@interface AKInflection : NSObject {

    NSMutableSet* _uncountableWords;
    NSMutableArray* _pluralRules;
    NSMutableArray* _singularRules;
}

+ (AKInflection*)sharedInflection;

- (void)addInflectionsFromFile:(NSString*)path;
- (void)addInflectionsFromDictionary:(NSDictionary*)dictionary;

- (void)addUncountableWord:(NSString*)string;
- (void)addIrregularRuleForSingular:(NSString*)singular plural:(NSString*)plural;
- (void)addPluralRuleFor:(NSString*)rule replacement:(NSString*)replacement;
- (void)addSingularRuleFor:(NSString*)rule replacement:(NSString*)replacement;

- (NSString*)pluralize:(NSString*)string;
- (NSString*)singularize:(NSString*)string;

@end
