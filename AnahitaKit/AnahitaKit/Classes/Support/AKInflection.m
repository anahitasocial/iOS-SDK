//
//  AKInflection.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKInflection.h"


@interface AKInflectorRule : NSObject

@property (strong) NSString* rule;
@property (strong) NSString* replacement;

+ (AKInflectorRule*) rule:(NSString*)rule replacement:(NSString*)replacement;

@end

@implementation AKInflectorRule

+ (AKInflectorRule*) rule:(NSString*)rule replacement:(NSString*)replacement {
    AKInflectorRule* result;
    if ((result = [[self alloc] init] )) {
        [result setRule:rule];
        [result setReplacement:replacement];
    }
    return result;
}

@end

static NSString *rules = @"{ pluralRules = ( ( \"$\", s, ), ( \"s$\", s, ), ( \"(ax|test)is$\", \"$1es\", ), ( \"(octop|vir)us$\", \"$1i\", ), ( \"(alias|status)$\", \"$1es\", ), ( \"(bu)s$\", \"$1ses\", ), ( \"(buffal|tomat)o$\", \"$1oes\", ), ( \"([ti])um$\", \"$1a\", ), ( \"sis$\", ses, ), ( \"(?:([lr])f)$\", \"$1ves\", ), ( \"(?:(?:([^f])fe))$\", \"$1ves\", ), ( \"(hive)$\", \"$1s\", ), ( \"([^aeiouy]|qu)y$\", \"$1ies\", ), ( \"(x|ch|ss|sh)$\", \"$1es\", ), ( \"(matr|vert|ind)(?:ix|ex)$\", \"$1ices\", ), ( \"([m|l])ouse$\", \"$1ice\", ), ( \"^(ox)$\", \"$1en\", ), ( \"(quiz)$\", \"$1zes\", ), ); singularRules = ( ( \"(.)s$\", \"$1\", ), ( \"(n)ews$\", \"$1ews\", ), ( \"([ti])a$\", \"$1um\", ), ( \"(analy|ba|diagno|parenthe|progno|synop|the)ses$\", \"$1sis\", ), ( \"(^analy)ses$\", \"$1sis\", ), ( \"([^f])ves$\", \"$1fe\", ), ( \"(hive)s$\", \"$1\", ), ( \"(tive)s$\", \"$1\", ), ( \"([lr])ves$\", \"$1f\", ), ( \"([^aeiouy]|qu)ies$\", \"$1y\", ), ( \"series$\", series, ), ( \"movies$\", movie, ), ( \"(x|ch|ss|sh)es$\", \"$1\", ), ( \"([m|l])ice$\", \"$1ouse\", ), ( \"(bus)es$\", \"$1\", ), ( \"(o)es$\", \"$1\", ), ( \"(shoe)s$\", \"$1\", ), ( \"(cris|ax|test)es$\", \"$1is\", ), ( \"(octop|vir)i$\", \"$1us\", ), ( \"(alias|status)es$\", \"$1\", ), ( \"^(ox)en\", \"$1\", ), ( \"(vert|ind)ices$\", \"$1ex\", ), ( \"(matr)ices$\", \"$1ix\", ), ( \"(quiz)zes$\", \"$1\", ), ); irregularRules = ( ( person, people, ), ( man, men, ), ( child, children, ), ( sex, sexes, ), ( move, moves, ), ( database, databases, ), ); uncountableWords = ( equipment, information, rice, money, species, series, fish, sheep, ); }";

@interface AKInflection(PrivateMethods)
- (NSString*)_applyInflectorRules:(NSArray*)rules toString:(NSString*)string;
@end

@implementation AKInflection

+ (AKInflection*)sharedInflection
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;    
}

- (AKInflection*)init
{
    if ((self = [super init]))
    {
        _uncountableWords = [[NSMutableSet alloc] init];
        _pluralRules = [[NSMutableArray alloc] init];
        _singularRules = [[NSMutableArray alloc] init];
        
        NSData* plistData = [rules dataUsingEncoding:NSUTF8StringEncoding];
        NSString *error;
        NSPropertyListFormat format;
        
        [self addInflectionsFromDictionary:[NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]];
    }
    return self;
}

- (void)addInflectionsFromFile:(NSString*)path {
    [self addInflectionsFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
}

- (void)addInflectionsFromDictionary:(NSDictionary*)dictionary {
    for (NSArray* pluralRule in [dictionary objectForKey:@"pluralRules"]) {
        [self addPluralRuleFor:[pluralRule objectAtIndex:0] replacement:[pluralRule objectAtIndex:1]];
    }
    
    for (NSArray* singularRule in [dictionary objectForKey:@"singularRules"]) {
        [self addSingularRuleFor:[singularRule objectAtIndex:0] replacement:[singularRule objectAtIndex:1]];
    }
    
    for (NSArray* irregularRule in [dictionary objectForKey:@"irregularRules"]) {
        [self addIrregularRuleForSingular:[irregularRule objectAtIndex:0] plural:[irregularRule objectAtIndex:1]];
    }
    
    for (NSString* uncountableWord in [dictionary objectForKey:@"uncountableWords"]) {
        [self addUncountableWord:uncountableWord];
    }
}

- (void)addUncountableWord:(NSString*)string {
    [_uncountableWords addObject:string];
}

- (void)addIrregularRuleForSingular:(NSString*)singular plural:(NSString*)plural {
    NSString* singularRule = [NSString stringWithFormat:@"%@$", plural];
    [self addSingularRuleFor:singularRule replacement:singular];
    
    NSString* pluralRule = [NSString stringWithFormat:@"%@$", singular];
    [self addPluralRuleFor:pluralRule replacement:plural];
}

- (void)addPluralRuleFor:(NSString*)rule replacement:(NSString*)replacement {
    [_pluralRules insertObject:[AKInflectorRule rule:rule replacement: replacement] atIndex:0];
}

- (void)addSingularRuleFor:(NSString*)rule replacement:(NSString*)replacement {
    [_singularRules insertObject:[AKInflectorRule rule:rule replacement: replacement] atIndex:0];
}

- (NSString*)pluralize:(NSString*)singular {
    return [self _applyInflectorRules:_pluralRules toString:singular];
}

- (NSString*)singularize:(NSString*)plural {
    return [self _applyInflectorRules:_singularRules toString:plural];
}

- (NSString*)_applyInflectorRules:(NSArray*)rules toString:(NSString*)string {
    if ([_uncountableWords containsObject:string]) {
        return string;
    }
    else {
        for (AKInflectorRule* rule in rules) {
            NSRange range = NSMakeRange(0, [string length]);
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[rule rule] options:0 error:nil];
            if ([regex firstMatchInString:string options:0 range:range]) {
                // NSLog(@"rule: %@, replacement: %@", [rule rule], [rule replacement]);
                return [regex stringByReplacingMatchesInString:string options:0 range:range withTemplate:[rule replacement]];
            }
        }
        return string;
    }  
}

@end
