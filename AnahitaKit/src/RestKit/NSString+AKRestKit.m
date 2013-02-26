//
//  NSString+AKRestKit.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-16.
//
//

#import "AKFoundation.h"
#import "AFHTTPClient.h"

@implementation NSString (AKRestKit)

- (NSString *)stringByAppendingDictionaryQueryParamaters:(NSDictionary*)queryParameters
{
    NSString *query = AFQueryStringFromParametersWithEncoding(queryParameters, NSUTF8StringEncoding);
    return [self stringByAppendingStringQueryParamaters:query];
}

- (NSString *)stringByAppendingStringQueryParamaters:(NSString*)queryParameters
{
    NSString *newString;
    
    if ( nil != queryParameters ) {
        
        newString = AKNSRegularExpressionReplace(self, @"\\?$", @"", nil);
        
        if ([newString rangeOfString:@"?"].location == NSNotFound) {
            newString = [newString stringByAppendingFormat:@"?%@", queryParameters];
            
        } else {
            newString = [newString stringByAppendingFormat:@"&%@", queryParameters];
        }
    }
    
    else {
        newString = [NSString stringWithString:self];
    }
    
    return newString;
}

@end
