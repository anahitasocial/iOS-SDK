//
//  AHObjectEqualityRule.m
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

#import "AHObjectEqualityRule.h"
#import "NSObject+Validation.h"

@implementation AHObjectEqualityRule

@synthesize objectToCompare;

+ (void)addRuleToObject:(id)obj1 object:(id)obj2 keyPath:(NSString *)keyPath message:(NSString *)message 
{
	AHValidationRule *rule = [[self alloc] initWithObject:obj1 object:obj2 keyPath:keyPath message:message];
	[obj1 addValidationRule:rule];
}

- (id)initWithObject:(id)obj1 
			  object:(id)obj2 
			 keyPath:(NSString *)aKeyPath
			 message:(NSString *)message 
{
	if((self = [super initWithObject:obj1 keyPath:aKeyPath message:message])) {
		objectToCompare = obj2;
	}
	return self;
}

- (BOOL)passes {
	return [[self.object valueForKey:self.keyPath] isEqual:[self.objectToCompare valueForKeyPath:self.keyPath]];
}

@end
