//
//  AHRegexRule.m
//
//  Copyright (c) 2012 Auerhaus Development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// 

#import "AHRegexRule.h"
#import "NSObject+Validation.h"

@implementation AHRegexRule

@synthesize regex;

+ (void)addRuleToObject:(id)obj keyPath:(NSString *)keyPath expression:(NSString *)expr message:(NSString *)message
{
	AHValidationRule *rule = [[self alloc] initWithObject:obj keyPath:keyPath expression:expr message:message];
	[obj addValidationRule:rule];
}

- (id)initWithObject:(id)obj 
			 keyPath:(NSString *)keyPath 
		  expression:(NSString *)expr 
			 message:(NSString *)message
{
	if((self = [super initWithObject:obj keyPath:keyPath message:message]))
	{
		NSError *error = nil;
		NSInteger regexOptions = NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines;
		self.regex = [NSRegularExpression regularExpressionWithPattern:expr 
															   options:regexOptions 
																 error:&error];
		if(error || (self.regex == nil)) {
			return nil;
		}
	}
	
	return self;
}

- (BOOL)passes {
	id value = [self.object valueForKey:self.keyPath];
	NSRange searchRange = NSMakeRange(0, [value length]);
	NSRange matchedRange = [regex rangeOfFirstMatchInString:value 
													options:0 
													  range:searchRange];	
	return (matchedRange.length != 0);
}

@end
