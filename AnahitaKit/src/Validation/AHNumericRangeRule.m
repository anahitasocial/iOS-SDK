//
//  AHNumericRangeRule.m
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

#import "AHNumericRangeRule.h"
#import "NSObject+Validation.h"

@implementation AHNumericRangeRule

@synthesize lowerBound, upperBound;

+ (void)addRuleToObject:(id)obj keyPath:(NSString *)keyPath lowerBound:(NSNumber *)lowerBound upperBound:(NSNumber *)upperBound message:(NSString *)message {
	AHValidationRule *rule = [[self alloc] initWithObject:obj keyPath:keyPath lowerBound:lowerBound upperBound:upperBound message:message];
	[obj addValidationRule:rule];
}

- (id)initWithObject:(id)obj keyPath:(NSString *)keyPath lowerBound:(NSNumber *)aLowerBound upperBound:(NSNumber *)anUpperBound message:(NSString *)message {
	if((self = [super initWithObject:obj keyPath:keyPath message:message])) {
		lowerBound = aLowerBound;
		upperBound = anUpperBound;
	}
	return self;
}

- (BOOL)passes {
	NSAssert(self.lowerBound != nil || self.upperBound != nil, @"Incorrectly configured numeric range rule");
	
	Float64 value = [[self.object valueForKey:self.keyPath] doubleValue];
	
	if(self.lowerBound != nil && self.upperBound != nil)
		return (value >= [self.lowerBound doubleValue] && value <= [self.upperBound doubleValue]);
	else if(self.lowerBound != nil)
		return (value >= [self.lowerBound doubleValue]);
	else if(self.upperBound != nil)
		return (value <= [self.upperBound doubleValue]);
	else
		return NO;
}

@end
