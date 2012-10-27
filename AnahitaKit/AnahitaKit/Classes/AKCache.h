//
//  ANCache.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-05-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@interface AKCache : NSObject
{
    
@protected
	NSString *_documentsDirectory;
	NSString *_cacheFileUrl;
	NSMutableDictionary *_dictCache;
    
}

+ (id)sharedCache;

//sets the data for a key
- (void)setData:(NSData*)data forKey:(NSString*)key;

//return whether the cache has the key
- (BOOL)hasDataForKey:(NSString*)key;

//return data for a key
- (NSData*)dataForKey:(NSString*)key;

//private method to sanitize a key
- (NSString*)_sanitizeKey:(NSString*)key;

@end
