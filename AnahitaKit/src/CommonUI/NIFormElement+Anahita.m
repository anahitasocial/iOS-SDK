//
//  NIFormElement+Anahita.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-21.
//
//

#import "NIFormElement+Anahita.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@interface NICellFactory(SwizzleCellFactoryMethod)
@end

@implementation NICellFactory(SwizzleCellFactoryMethod)

+ (UITableViewCell *)___cellWithClass:(Class)cellClass
                         tableView:(UITableView *)tableView
                            object:(id)object
{

  UITableViewCell* cell = nil;

  NSString* identifier = NSStringFromClass(cellClass);

  cell = [tableView dequeueReusableCellWithIdentifier:identifier];

  if (nil == cell) {
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    if ([object respondsToSelector:@selector(cellStyle)]) {
      style = [object cellStyle];
    }
    cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
    if ( [object respondsToSelector:@selector(styleTags)]) {
            [[object styleTags] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               [cell addStyleTag:obj];
            }];
    }
  }

  // Allow the cell to configure itself with the object's information.
  if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
    [(id<NICell>)cell shouldUpdateCellWithObject:object];
  }

  return cell;
}

@end

__attribute__((constructor))
void NIFormElement_Anahita_Initialize()
{
    [NICellFactory jr_swizzleClassMethod:@selector(cellWithClass:tableView:object:) withClassMethod:@selector(___cellWithClass:tableView:object:) error:nil];
}

@implementation NICellObject(StylerTag)

SYNTHESIZE_PROPERTY_STRONG(NSArray*, setStyleTags, styleTags);

@end

@implementation NISwitchFormElement(Anahita)

- (id)elementValue
{
    return [NSNumber numberWithBool:self.value];
}

@end

@implementation NITextInputFormElement(Anahita)

- (id)elementValue
{
    return self.value;
}

@end

@implementation NISliderFormElement(Anahita)

- (id)elementValue
{
    return [NSNumber numberWithFloat:self.value];
}

@end

@implementation NISegmentedControlFormElement(Anahita)

- (id)elementValue
{
    return nil;
}

@end

@implementation NIDatePickerFormElement(Anahita)

- (id)elementValue
{
    return self.date;
}

@end
