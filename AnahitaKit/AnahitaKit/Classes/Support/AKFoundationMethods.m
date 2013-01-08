//
//  AKFoundationMethods.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#pragma mark -
#pragma mark NSRegularExpression Methods

NSString* AKNSRegularExpressionReplace(NSString *string, NSString *pattern, NSString *replacement, NSError **error)
{
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:error];
    [expr replaceMatchesInString:mutableString options:0 range:NSMakeRange(0, [string length]) withTemplate:replacement];
    return (NSString*)mutableString;
}

BOOL AKNSRegularExpressionMatch(NSString *string, NSString *pattern, NSError **error)
{
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:error];
    return [expr numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])] > 0;
}


#pragma mark - 
#pragma mark - NSString methods

Class AKNSClassFromListOfStrings(NSString * class1,...)
{
    va_list args;
    va_start(args, class1);    
    NSString* className = class1;
    Class class  = NULL;
    while (className != nil) {
        class = NSClassFromString(className);
        if ( NULL != class )
            break;
        className = va_arg(args, NSString*);
    }
    va_end(args);
    return class;
}