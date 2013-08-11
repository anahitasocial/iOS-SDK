//
//  NSObject+Validation.m
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

#import "NSObject+Validation.h"
#import <objc/runtime.h>

static char * const AHValidationRulesArrayKey = "AHValidationRulesArray";

@implementation NSObject (Validation)

- (NSMutableArray *)validationRules {
	NSMutableArray *rules = objc_getAssociatedObject(self, AHValidationRulesArrayKey);
	if(rules == nil)
		self.validationRules = rules = [NSMutableArray array];
	return rules;
}

- (void)setValidationRules:(NSMutableArray *)validationRules {
	objc_setAssociatedObject(self, AHValidationRulesArrayKey, 
							 validationRules, OBJC_ASSOCIATION_RETAIN);
}

- (void)addValidationRule:(AHValidationRule *)rule {
	if(self.validationRules == nil)
		self.validationRules = [NSMutableArray array];
	[self.validationRules addObject:rule];
}

- (void)removeValidationRule:(AHValidationRule *)rule {
	[self.validationRules removeObject:rule];
}

- (void)removeAllValidationRules {
	[self.validationRules removeAllObjects];
}

- (NSArray *)validate {
	NSMutableArray *messages = [NSMutableArray array];
	for(AHValidationRule *rule in self.validationRules) {
		if(![rule passes])
			[messages addObject:rule.failureMessage];
	}
	return messages;
}

@end
