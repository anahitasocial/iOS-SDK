//
//  RKObjectPaginator+Anahita.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RKManagedObjectLoader.h"
#import "RKObjectPaginator+Anahita.h"
#import "RKObjectPaginator.h"
#import "RKObjectMapping.h"
#import <objc/runtime.h>
#import "NIRuntimeClassModifications.h"

__attribute__((constructor))
static void initialize()
{
    NISwapInstanceMethods([RKObjectPaginator class], @selector(loadPage:), @selector(_loadPage:));
    NISwapInstanceMethods([RKObjectPaginator class], @selector(initWithPatternURL:mappingProvider:),
                          @selector(_initWithPatternURL:mappingProvider:));
}

@interface RKObjectPaginator() <RKObjectLoaderDelegate>
{
    RKObjectLoader *objectLoader;
    NSUInteger currentPage;
    RKObjectMapping *_objectMapping;    
}


- (void)_loadPage;

@property (nonatomic, strong) RKObjectLoader *objectLoader;
@property (nonatomic, readonly) NSUInteger offset;

@end

@implementation RKObjectPaginator (Anahita)

- (id)_initWithPatternURL:(RKURL *)aPatternURL mappingProvider:(RKObjectMappingProvider *)aMappingProvider {
    NSString *resourcePath = [aPatternURL.resourcePath stringByAppendingStringQueryParamaters:@"limit=:perPage&start=:offset"];
    aPatternURL = [RKURL URLWithBaseURL:aPatternURL.baseURL resourcePath:resourcePath];
    return [self _initWithPatternURL:aPatternURL mappingProvider:aMappingProvider];
}

- (void)_loadPage:(NSUInteger)pageNumber
{
    NSAssert(self.mappingProvider, @"Cannot perform a load with a nil mappingProvider.");
    NSAssert(! objectLoader, @"Cannot perform a load while one is already in progress.");
    currentPage = pageNumber;
    
    if (self.objectStore) {
        self.objectLoader = [[RKManagedObjectLoader alloc] initWithURL:self.URL mappingProvider:self.mappingProvider objectStore:self.objectStore] ;
    } else {
        self.objectLoader = [[RKObjectLoader alloc] initWithURL:self.URL mappingProvider:self.mappingProvider];
    }
    
    if ([self.configurationDelegate respondsToSelector:@selector(configureObjectLoader:)]) {
        [self.configurationDelegate configureObjectLoader:objectLoader];
    }
    self.objectLoader.method = RKRequestMethodGET;
    self.objectLoader.delegate = self;
    RKObjectMapping *mapping = self.objectMapping;
    self.objectLoader.objectMapping = mapping;
    
    if ([self.delegate respondsToSelector:@selector(paginator:willLoadPage:objectLoader:)]) {
        [self.delegate paginator:self willLoadPage:pageNumber objectLoader:self.objectLoader];
    }
    
    [self.objectLoader send];
}

- (BOOL)isLoading
{
    return self.objectLoader != nil;
}

- (NSUInteger)offset
{
    return MAX(self.currentPage, 0) * self.perPage;
}

- (void)setObjectMapping:(RKObjectMapping *)objectMapping
{
    objc_setAssociatedObject(self, @"objectMapping", objectMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RKObjectMapping*)objectMapping
{
    return objc_getAssociatedObject(self, @"objectMapping");
}

@end
