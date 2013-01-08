//
//  AKAttributedLabel.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import <objc/runtime.h>

//provides method to set and get object for a text result

void *const kNSTextCheckingResultObjectKey = @"kNSTextCheckingResultObjectKey";

@interface NSTextCheckingResult (Object)

- (void)setObject:(id)object;
- (id)object;

@end

@implementation NSTextCheckingResult (Object)

- (void)setObject:(id)object
{
    objc_setAssociatedObject(self, kNSTextCheckingResultObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)object
{
    return objc_getAssociatedObject(self,  kNSTextCheckingResultObjectKey);
}

@end

static NSMutableDictionary *sharedAttributeObjectRegistery;

//register an object and return a link to be used within an attribute
NSString* AKLinkTagFromObject(id object, NSString* text)
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedAttributeObjectRegistery = [[NSMutableDictionary alloc] init];
    });
    NSString *hash = [NSString stringWithFormat:@"%d", [object hash]];
    [sharedAttributeObjectRegistery setValue:object forKey:hash];
    return [NSString stringWithFormat:@"<a href=\"object://%@\">%@</a>", hash, text];
}

//attribute label implementing the delegate
@interface AKAttributedLabel() <NIAttributedLabelDelegate> @end

@implementation AKAttributedLabel
{
    id<NIAttributedLabelDelegate> __delegate;
}
- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.delegate = self;
    }    
    return self;
}
- (void)setDelegate:(id<NIAttributedLabelDelegate>)delegate
{
    //we want to hanle action sheet delegate method
    //ourselve. see method below
    if ( delegate != self) {
        __delegate = delegate;
    }
    [super setDelegate:self];
}

- (void)setText:(NSString *)text
{
    if ( NULL == text )
    {
        [super setText:text];
        return;
    }
    NSError *error;
    NSRegularExpression *rg = [NSRegularExpression regularExpressionWithPattern:@"(?i)<a\\s*(?i)href\\s*=\\s*(\"([^\"]*\")|'[^']*'|([^'\">\\s]+))>(.+?)</a>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [rg matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableString *string = [NSMutableString stringWithString:text];
    NSInteger nextoffset  = 0;
    NSMutableDictionary *links = [NSMutableDictionary dictionary];
    if ( matches.count > 0 ) {
        //lets extra the content and the href and manually add them as links
        for(NSTextCheckingResult *match in matches)
        {
            //ranges variables
            NSRange linkRange,contentRange,matchRange;
            
            linkRange = [match rangeAtIndex:2];
            contentRange = [match rangeAtIndex:4];
            matchRange   = match.range;
            //replacement string
            NSString *replacement = [text substringWithRange:contentRange];
            NSString *link = [text substringWithRange:linkRange];
            //apply the offset from the last
            matchRange.location   += nextoffset;
            
            if ( link.length > 0 ) {
                NSString *key = NSStringFromRange(NSMakeRange(matchRange.location, contentRange.length));
                [links setValue:link forKey:key];
            }
            
            //adjust the offset
            nextoffset += contentRange.length - match.range.length;            
            [string replaceCharactersInRange:matchRange withString:replacement];

        }
    }
    
    [super setText:string];
    
    [links enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSRange range = NSRangeFromString(key);
            NSURL *url = [NSURL URLWithString:obj];
            [self addLink:url range:range];
    }];
}

#pragma mark -
#pragma mark - NIAttributedLabelDelegate

//forward to the delegate
- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    //set the object 
    if ( [result.URL.scheme isEqualToString:@"object"] ) {
        NSString *objectId = [NSString stringWithFormat:@"%d", [result.URL.host intValue]];
        if ( sharedAttributeObjectRegistery ) {
            id object = [sharedAttributeObjectRegistery valueForKey:objectId];
            [result setObject:object];
        }
    }
    if ( [__delegate respondsToSelector:@selector(attributedLabel:didSelectTextCheckingResult:atPoint:)]) {
        [__delegate attributedLabel:attributedLabel didSelectTextCheckingResult:result atPoint:point];
    }
        
}

//if the URL is local then don't ever show the actionsheet and locall handle that
//otherwise forward to the delegate
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel shouldPresentActionSheet:(UIActionSheet *)actionSheet withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    if ( [result.URL.scheme isEqualToString:@"object"] ) {
        return NO;
    }
    if ( [__delegate respondsToSelector:@selector(attributedLabel:shouldPresentActionSheet:withTextCheckingResult:atPoint:)]) {
        return [__delegate attributedLabel:attributedLabel shouldPresentActionSheet:actionSheet withTextCheckingResult:result atPoint:point];
    }
    return NO;
}

@end


