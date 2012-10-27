//
//  UIImageView+Loader.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-04-20.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "UIImageView+Loader.h"
#import "AKCache.h"

@implementation UIImageView (Loader)

- (void)setImageWithURL:(NSURL*)aURL
{    
    [self setImageWithURL:aURL onComplete:nil];
}

- (void)setImageWithURL:(NSURL *)aURL onComplete :(void (^)(UIImageView*))onComplete
{
    if ( aURL != nil && [[aURL absoluteString] length] > 0 )
    {
        dispatch_queue_t queue = dispatch_get_global_queue(
                                                           DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            AKCache *cache   = [AKCache sharedCache];
            NSData *data;
            if ( ![cache hasDataForKey:[aURL absoluteString]] ) 
            {
                data = [NSData dataWithContentsOfURL:aURL];
                [cache setData:data forKey:[aURL absoluteString]];
            }
            
            data = [cache dataForKey:[aURL absoluteString]];
            
            //only set the data if there's any
            if ( [data length ] > 0 )
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = [UIImage imageWithData:data];
                    if ( onComplete )
                        onComplete(self);
                });
        });
    }
}

@end
