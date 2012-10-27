//
//  ANCache.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-05-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKCache.h"
#import <CommonCrypto/CommonDigest.h>

#define kDefaultCacheFile @"datacache.plist"

static id _sharedInstance = nil;

@implementation AKCache

+ (id)sharedCache;
{
    @synchronized(self)
	{
		if ( _sharedInstance == nil )
		{
			_sharedInstance = [[AKCache alloc] init];
		}
	}
	return _sharedInstance;    
}

- (id)init
{
	if ( (self = [super init]) )
	{
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		
		_documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"RVThumbnails"];
		NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:_documentsDirectory])
            [[NSFileManager defaultManager] createDirectoryAtPath:_documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
		// the path to the cache map
		_cacheFileUrl = [_documentsDirectory stringByAppendingPathComponent:kDefaultCacheFile];
        
		_dictCache = [[NSMutableDictionary alloc] initWithContentsOfFile:_cacheFileUrl];
		
		if ( _dictCache == nil )
		{
			_dictCache = [[NSMutableDictionary alloc] init];
		}
	}
	
	return self;
}

//sets the data for a key
- (void)setData:(NSData*)data forKey:(NSString*)key
{
    @synchronized(self)
    {
        key = [self _sanitizeKey:key];    
        
        NSString *cachedFile = [_documentsDirectory stringByAppendingPathComponent:key];
        
        if ( [data writeToFile:cachedFile atomically:YES] )
        {
            [_dictCache setValue:cachedFile forKey:key]; 
            [_dictCache writeToFile:_cacheFileUrl atomically:YES];
        }        
    }    
    
}

//return whether the cache has the key
- (BOOL)hasDataForKey:(NSString*)key
{
    @synchronized(self)    
    {
        key = [self _sanitizeKey:key];    
        return [_dictCache valueForKey:key] != nil;        
    }
}

//return data for a key
- (NSData*)dataForKey:(NSString*)key
{
    @synchronized(self)    
    {
        key = [self _sanitizeKey:key];
        NSString *cachedFile = [_dictCache valueForKey:key];
        NSData *data = nil;
        if ( cachedFile != nil ) {
            data = [NSData dataWithContentsOfFile:cachedFile];
        }    
        return data;        
    }
}

- (NSString *)_sanitizeKey:(NSString *)key
{
    const char *cStr = [key UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    key = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
    
    //key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];    
    //key = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
    return key;    
}

@end
