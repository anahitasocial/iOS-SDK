//
//  AHStringLengthRule.m
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

#import "AHStringLengthRule.h"
#import "NSObject+Validation.h"

@implementation AHStringLengthRule

@synthesize minLength, maxLength;

+ (void)addNonemptyStringRuleToObject:(id)obj keyPath:(NSString *)keyPath message:(NSString *)message 
{
	AHValidationRule *rule = [[self alloc] initWithObject:obj keyPath:keyPath minLength:[NSNumber numberWithInteger:1] 
												maxLength:nil message:message];
	[obj addValidationRule:rule];
}

+ (void)addRuleToObject:(id)obj keyPath:(NSString *)keyPath minLength:(NSNumber *)minLength 
			  maxLength:(NSNumber *)maxLength message:(NSString *)message
{
	AHValidationRule *rule = [[self alloc] initWithObject:obj keyPath:keyPath minLength:minLength 
												maxLength:maxLength message:message];
	[obj addValidationRule:rule];
}

- (id)initWithObject:(id)obj keyPath:(NSString *)keyPath minLength:(NSNumber *)minimumLength 
		   maxLength:(NSNumber *)maximumLength message:(NSString *)message
{
	if((self = [super initWithObject:obj keyPath:keyPath message:message])) {
		minLength = minimumLength;
		maxLength = maximumLength;
	}
	return self;
}

- (BOOL)passes {
	NSAssert(self.maxLength != nil || self.minLength != nil, @"Invalid configuration for string length rule");

	NSInteger length = [[self.object valueForKey:self.keyPath] length];
	
	if(self.maxLength != nil && self.minLength != nil)
		return (length >= [self.minLength integerValue] && length <= [self.maxLength integerValue]);
	else if(self.maxLength != nil)
		return (length <= [self.maxLength integerValue]);
	else if(self.minLength != nil)
		return (length >= [self.minLength integerValue]);
	else
		return NO;
}

@end
