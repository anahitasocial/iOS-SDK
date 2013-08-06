//
//  RKAttributeMapping+CoreEntity.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-16.
//
//

#import "AKRestKit.h"
#import "NIRuntimeClassModifications.h"
#import <objc/runtime.h>

@interface RKAttributeMapping()

@property (nonatomic, copy, readwrite) RKPropertyTransformerBlock transformerBlock;

@end


@implementation RKAttributeMapping (CoreEntity)

SYNTHESIZE_PROPERTY_COPY(RKPropertyTransformerBlock, setTransformerBlock, getTransformerBlock)

+ (instancetype)attributeMappingForKey:(NSString *)key
        usingTransformerBlock:(RKPropertyTransformerBlock)block
{
    return [self attributeMappingFromKeyPath:key toKeyPath:key usingTransformerBlock:block];
}

+ (instancetype)attributeMappingFromKeyPath:(NSString *)sourceKeyPath
        toKeyPath:(NSString *)destinationKeyPath usingTransformerBlock:(RKPropertyTransformerBlock)block
{
    RKAttributeMapping *mapping = [self attributeMappingFromKeyPath:sourceKeyPath toKeyPath:destinationKeyPath];
    mapping.transformerBlock = block;
    return mapping;
}

- (id)copyWithZone:(NSZone *)zone
{
    RKAttributeMapping *copy = [super copyWithZone:zone];
    copy.transformerBlock = self.transformerBlock;
    return copy;
}

@end

__attribute__((constructor))
static void __initialize_RKMappingOperation_CoreEntity()
{
    NISwapInstanceMethods([RKMappingOperation class], @selector(transformValue:atKeyPath:toType:),
        @selector(_transformValue:atKeyPath:toType:));
}


@interface RKMappingOperation(CoreEntity)

- (id)_transformValue:(id)value atKeyPath:(NSString *)keyPath toType:(Class)destinationType;

@end

@implementation RKMappingOperation(CoreEntity)

- (id)_transformValue:(id)value atKeyPath:(NSString *)keyPath toType:(Class)destinationType
{
    id mapping = [self.objectMapping mappingForSourceKeyPath:keyPath];
    id transformedValue;
    RKPropertyTransformerBlock block = nil;
    if ( [mapping respondsToSelector:@selector(transformerBlock)] ) {
        block = [mapping transformerBlock];
    }
    if ( block ) {
        transformedValue = block(value, destinationType);
    } else {
        transformedValue =  [self _transformValue:value atKeyPath:keyPath toType:destinationType];
    }
    
    return transformedValue;
}

@end