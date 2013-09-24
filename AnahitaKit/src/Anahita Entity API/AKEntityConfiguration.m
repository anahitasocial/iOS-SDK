//
//  AKEntityConfiguration.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKEntityConfiguration.h"
#import "NSString+AKCore.h"
#import "RestKit.h"

@implementation AKEntityConfiguration

- (id)initWithObjectClass:(Class)class
{
    if ( self = [super init] ) {
        
        _objectClass   = class;
        _objectSerializer   = [RKObjectMapping mappingForClass:_objectClass];
        _objectMapping      = [AKObjectMapping mappingForClass:_objectClass];
        _objectManager = [AKGlobalConfiguration sharedInstance].objectManager;
        
        _collectionRootKeyPath = @"data";
        //set the defautl resource paths paths
        NSString *strClass = NSStringFromClass(class);
        NSArray *components = [strClass componentsSeparatedByCases];
        
        if ( [components count] > 2 ) {
            NSString *singular, *plural;
            if ( [[components objectAtIndex:0] isEqualToString:@"com"] ) {
                singular  = components.lastObject;
                plural    = [[AKInflection sharedInflection] pluralize:singular];                
            } else {
                singular  = [components objectAtIndex:[components count] - 2];
                plural    = [[AKInflection sharedInflection] pluralize:singular];
            }
            self.itemResourcePath  = [NSString stringWithFormat:@"/%@/%@/:identifier", plural,singular];
            self.collectionResourcePath = [NSString stringWithFormat:@"/%@", plural];
        }
    }
    
    return self;
}

- (Class)delegateProxyClass
{
    if ( nil == _delegateProxyClass ) {
        _delegateProxyClass = [AKEntityObjectDelegateProxy class];
    }
    return _delegateProxyClass;
}

#pragma mark -
#pragma mark Object Mapping

- (void)mapAttributes:(NSString*)attributeKeyPath, ... {
    va_list args;
    va_start(args, attributeKeyPath);
    NSMutableSet* attributeKeyPaths = [NSMutableSet set];
    
    for (NSString* keyPath = attributeKeyPath; keyPath != nil; keyPath = va_arg(args, NSString*)) {
        [attributeKeyPaths addObject:keyPath];
    }
    
    va_end(args);
    
    [self.objectSerializer mapAttributesFromSet:attributeKeyPaths];
    [self.objectMapping mapAttributesFromSet:attributeKeyPaths];
}

- (void)mapKeyPath:(NSString*)sourceKeyPath toAttribute:(NSString*)destinationAttribute
{
    [self.objectMapping mapKeyPath:sourceKeyPath toAttribute:destinationAttribute];
    [self.objectSerializer mapKeyPath:destinationAttribute toAttribute:sourceKeyPath];
}

- (AKObjectMapping*)collectionMapping
{
    AKObjectMapping *mapping = [self.objectMapping copy];
    mapping.rootKeyPath = self.collectionRootKeyPath;
    return mapping;
}

@end
