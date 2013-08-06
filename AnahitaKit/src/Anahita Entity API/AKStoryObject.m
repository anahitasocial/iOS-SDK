//
//  AKStoryObject.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@implementation AKStoryQueryObject

- (id)init
{
    if ( self = [super init] ) {
        [_querySerializer mapKeyPath:@"components" toAttribute:@"component"];
        [_querySerializer mapKeyPath:@"names" toAttribute:@"name"];        
        [_querySerializer mapKeyPath:@"owner.identifier" toAttribute:@"oid"];
        [_querySerializer mapKeyPath:@"subjectIds" toAttribute:@"subject"];
        [_querySerializer mapKeyPath:@"excludeCommentStories" toAttribute:@"excludeCommentStories"];
        _excludeCommentStories = YES;
    }
    return self;
}

- (NSDictionary*)serializedValues
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super serializedValues]];    
    if ( !self.owner )
        [dict setValue:@"leaders" forKey:@"filter"];
    return dict;
}

@end

@implementation AKStoryObject
{
    id _object;
}
+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{    
    [configuration.objectMapping mapAttributes:@"name",@"component", nil];
    [configuration.objectMapping mapRelationship:@"object" toObjectClass:[AKMediumObject class]];
    [configuration.objectMapping mapRelationship:@"target" toObjectClass:[AKActorObject class]];
    [configuration.objectMapping mapRelationship:@"targets" toObjectClass:[AKActorObject class]];
    
    [configuration.objectMapping mapRelationship:@"objects" toObjectClass:[AKMediumObject class]];
    [configuration.objectMapping mapRelationship:@"subject" toObjectClass:[AKActorObject class]];
    [configuration.objectMapping mapAttributes:@"commands", nil];
}

- (AKMediumObject*)object
{
    if ( NULL == _object && [self.objects count] > 0 ) {
        _object = [self.objects objectAtIndex:0];
    }
    return _object;    
}

- (void)setObject:(id)object
{
    _object = object;
    [(AKEntityObject*)_object setCommands:self.commands];
}

- (NSNumber*)voteUpCount
{
    return [self.object voteUpCount];
}

- (void)voteUp:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    //forward this to the object
    [self.object voteUp:onSuccess onFailure:onFailure];
}

- (void)voteDown:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    //forward this to the object
    [self.object voteDown:onSuccess onFailure:onFailure];
}

@end
