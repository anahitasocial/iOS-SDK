//
//  AKCoreCellCatalogs.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//
#import "AKCoreCellCatalogs.h"
#import "UIImageView+AFNetworking.h"
#import "NIAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation AKEntityCellObject

- (id)initWithEntityObject:(AKEntityObject*)entityObject
        cellClass:(Class)cellClass
        cellActions:(NSArray*)cellActions

{
    if ( self = [super initWithCellClass:cellClass] ) {
        _entityObject = entityObject;
        _cellActions  = cellActions;
    }
    return self;
}

@end

@implementation AKEntityObjectCell

- (BOOL)shouldUpdateCellWithObject:(AKEntityCellObject*)cellObject
{
    _cellObject = cellObject;
    return YES;
}

@end

@implementation AKActorObjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    style = UITableViewCellStyleDefault;
    
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.backgroundColor = HEXCOLOR(0xffffff);
        self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

}

- (BOOL)shouldUpdateCellWithObject:(AKEntityCellObject*)cellObject
{
    [super shouldUpdateCellWithObject:cellObject];
    
    AKActorObject *actor = (AKActorObject*)cellObject.entityObject;
    self.textLabel.text = actor.name;
    NSURL *url = [actor.imageURL imageURLWithImageSize:kAKSquareImageURL];
    if ( url ) {
        [self.imageView setImageWithURL:url placeholderImage:kAKDefaultAvatarImage];
    } else {
        [self.imageView setImage:kAKDefaultAvatarImage];
    }        

    return YES;
}

@end

#pragma mark - 

static inline CGFloat AKMediumCellContentPaddingHeightForEntityMetrics(AKMediumCellEntityMetrics metric) {
    return metric.mediaHeight > 0 ? 10 : 0;
}


@interface AKMediumObjectCell() <NIAttributedLabelDelegate>
@end

@implementation AKMediumObjectCell
{
    //labels
    NIAttributedLabel *_bodyLabel;
    NIAttributedLabel *_titleLabel;
    NIAttributedLabel *_actionLabel;
    UIImageView *_contentImageView;
    
    UIView *_actionContainer;
    
    CGRect _contentRect;   
}

+ (AKMediumCellElementMetrics)cellElementsMetrics
{
    AKMediumCellElementMetrics metrics;
    metrics.avatarSize       = CGSizeMake(30, 30);
    metrics.cellPadding      = UIEdgeInsetsMake2(7.5,5);
    metrics.contentPadding   = UIEdgeInsetsMake2(5,5);
    metrics.actionsBoxHeight = 35;
    return metrics;    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.detailTextLabel removeFromSuperview];
        [self.textLabel removeFromSuperview];
        _bodyLabel  = [[AKAttributedLabel alloc] initWithFrame:CGRectZero];
        
        
        //configure body label
        _bodyLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.backgroundColor = [UIColor clearColor];
        _bodyLabel.linkColor = HEXCOLOR(0x098ED1);
        _bodyLabel.textColor = HEXCOLOR(0x000000);
        _bodyLabel.autoDetectLinks = YES;
        _bodyLabel.deferLinkDetection = YES;
        _bodyLabel.delegate = self;
        _titleLabel = [[AKAttributedLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _titleLabel.linkColor = HEXCOLOR(0x098ED1);
        _titleLabel.autoDetectLinks = YES;
        _titleLabel.delegate = self;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _actionLabel = [[AKAttributedLabel alloc] initWithFrame:CGRectZero];
        _actionLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _actionLabel.linkColor = HEXCOLOR(0x098ED1);
        _actionLabel.autoDetectLinks = YES;
        _actionLabel.delegate = self;
        _actionLabel.numberOfLines = 1;
        _actionLabel.backgroundColor = [UIColor clearColor];
        
        _likeButton = [UIButton buttonWithType:102];
        _likeButton.tintColor = HEXCOLOR(0xeeeeee);
        [_likeButton setImage:kAKLikeIconImage forState:UIControlStateNormal];
        [_likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [_likeButton setTitle:@"Unlike" forState:UIControlStateSelected];
        [_likeButton setTitleColor:HEXCOLOR(0x444444) forState:UIControlStateNormal];
        _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCellElement:)]];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        _contentImageView.userInteractionEnabled = YES;
        [_contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCellElement:)]];
        
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentImageView];
        [self.contentView addSubview:_bodyLabel];
        [self.contentView addSubview:_titleLabel];
        
        _actionContainer = [[UIView alloc] initWithFrame:CGRectZero];
        _actionContainer.backgroundColor = HEXCOLOR(0xf1f1f1);
        [_actionContainer addSubview:_likeButton];
        [_actionContainer addSubview:_actionLabel];
        
        [self.contentView addSubview:_actionContainer];
        
        [self.contentView setBackgroundColor:HEXCOLOR(0xffffff)];
        
        //lets add some shadow
        
        self.contentView.layer.shadowColor   = HEXCOLOR(0x000000).CGColor;
        self.contentView.layer.shadowOpacity = 0.8;
        self.contentView.layer.shadowOffset  = CGSizeMake(0, 0);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    AKMediumCellElementMetrics metrics = [[self class] cellElementsMetrics];
    
    self.contentView.frame  = UIEdgeInsetsInsetRect(self.bounds, metrics.cellPadding);    
    CGRect drawableBounds   = UIEdgeInsetsInsetRect(self.contentView.bounds, metrics.contentPadding);
    
    CGRect imageFrame,titleFrame;
    CGRectDivide(CGRectSetHeight(drawableBounds, metrics.avatarSize.height), &imageFrame, &titleFrame, metrics.avatarSize.width, CGRectMinXEdge);
    
    self.imageView.frame = imageFrame;
        
    _titleLabel.frame   = CGRectIncrementX(titleFrame, metrics.contentPadding.right);
    CGRectSetX(titleFrame, CGRectGetMinX(titleFrame) + metrics.contentPadding.right);

    _contentRect        = CGRectGetRemainder(drawableBounds, CGRectGetMaxY(self.imageView.frame), CGRectMinYEdge);
    _contentRect        = CGRectDecrementHeight(_contentRect, metrics.actionsBoxHeight);
    
    [self layoutContentForEntity:_cellObject.entityObject];
    
    _actionContainer.frame = CGRectMake(0, CGRectGetMaxY(_contentRect) + metrics.contentPadding.bottom, CGRectGetWidth(self.contentView.frame), metrics.actionsBoxHeight);
        
    _actionRect = CGRectInset(_actionContainer.bounds, 5, 5);
    
    _likeButton.frame   = CGRectSetWidth(_actionRect, 90);
 
    
    _actionLabel.frame  = CGRectSetHeight(CGRectSetX(CGRectSetWidth(_actionRect, 70), CGRectGetMaxX(_likeButton.frame) + 10),15);
    _actionLabel.center = CGPointSetY(_actionLabel.center, CGRectGetMidY(_actionRect));    
    _actionLabel.hidden = NO;
    
    self.contentView.layer.shadowRadius = 0.5;
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:
            CGRectInset(self.contentView.bounds, -0.25,-0.25)
        ].CGPath;
    
}

- (void)layoutContentForEntity:(AKEntityObject*)entity
{
    AKMediumCellEntityMetrics entityMetrics
        = [[self class] entityMetrics:entity constrainedToContentWidth:_contentRect.size.width cellWidth:self.frame.size.width];
    
    CGRect mediaRect, textRect;
    CGRectDivide(self.contentRect, &mediaRect, &textRect, entityMetrics.mediaHeight, CGRectMinYEdge);
    _bodyLabel.hidden = NO;
    if ( [entity conformsToProtocol:@protocol(AKPortriableBehavior)] )
    {
        _contentImageView.hidden = NO;
        CGRect imageFrame = CGRectSetWidth(mediaRect, CGRectGetWidth(self.frame));
        imageFrame        = CGRectSetX(imageFrame, CGRectGetMinX([self convertRect:CGRectZero toView:self.contentView]));
        _contentImageView.frame = imageFrame;
    }
    _bodyLabel.frame  = CGRectIncrementY(textRect, AKMediumCellContentPaddingHeightForEntityMetrics(entityMetrics));
}

- (void)didTapOnCellElement:(UITapGestureRecognizer*)tapGesture
{
    if ( tapGesture.view == _contentImageView && _cellObject )
    {
        AKEntityObject *entityObject = _cellObject.entityObject;
        NSNotification *notification =
            [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification
                object:entityObject];
        [self.notificationDelegate view:self didPostNotification:notification];
    }
    
    else if ( tapGesture.view == _likeButton && _cellObject ) {
        AKEntityObject *entityObject = _cellObject.entityObject;
        NSNotification *notification =
            [NSNotification notificationWithName:
                _likeButton.isSelected ? kAKViewDidSelectUnLikeActionNotification : kAKViewDidSelectLikeActionNotification
                object:entityObject];
        _likeButton.selected = !_likeButton.selected;
        [self.notificationDelegate view:self didPostNotification:notification];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView setImage:kAKDefaultAvatarImage];
    _bodyLabel.text = @"";
    _bodyLabel.delegate  = self;
    _titleLabel.delegate = self;
    _contentImageView.hidden = YES;
    _bodyLabel.hidden = YES;
    _likeButton.hidden = YES;
    _cellObject = NULL;
}

- (void)setCellThumbnail:(id)entityObject
{
    AKActorObject *actorObject = NULL;
    
    if ( [entityObject respondsToSelector:@selector(author)] )
        actorObject = [entityObject author];

    if ( [entityObject conformsToProtocol:@protocol(AKOwnableBehavior)] ) {
        if ( [entityObject owner] && [entityObject owner].administratorIds != nil ) {
            actorObject = [entityObject owner];
        }
    }
    
    if ( actorObject ) {
        NSURL *url = [actorObject.imageURL imageURLWithImageSize:kAKSquareImageURL];
        if ( url ) {
            [self.imageView setImageWithURL:url placeholderImage:kAKDefaultAvatarImage];
        } else {
           
        }
    }
}

- (void)setCellTitle:(id)entityObject
{
    AKActorObject *actorObject = NULL;
    
    if ( [entityObject respondsToSelector:@selector(author)] )
        actorObject = [entityObject author];

    if ( [entityObject conformsToProtocol:@protocol(AKOwnableBehavior)] ) {
        if ( [entityObject owner] && [entityObject owner].administratorIds != nil ) {
            actorObject = [entityObject owner];
        }
    }
    
    if ( actorObject ) {
         self.titleLabel.text  = [NSString stringWithFormat:@"%@",
            AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:actorObject],
                    actorObject.name)
            ];       

    }
}

- (void)setCellBody:(id)entityObject
{    
    if ( [entityObject conformsToProtocol:@protocol(AKPortriableBehavior)]) {
        NSURL *imageURL = [[entityObject imageURL] imageURLWithImageSize:kAKMediumImageURL];
        [_contentImageView setImageWithURL:imageURL];
    }
    
    _bodyLabel.text   = [entityObject body];
}

- (void)setCellActions:(id)entityObject
{
    NSMutableArray *actions = [NSMutableArray array];
    
    if ( [entityObject respondsToSelector:@selector(voteUpCount)]
        && [entityObject voteUpCount].intValue > 0 )
      {
        
        NSNotification *notification =
            [NSNotification notificationWithName:kAKViewDidSelectObjectVotersActionNotification object:entityObject];
          
        NSString* actionLabel = [NSString stringWithFormat:@"%d Likes", [entityObject voteUpCount].intValue];
        [actions addObject:AKLinkTagFromObject(notification, actionLabel)];
    }
    
    _actionLabel.text = [actions componentsJoinedByString:@" "];
    
    _likeButton.selected = NO;
    
    if ( [entityObject canUnVote] ) {
        _likeButton.selected = YES;
    }
    _likeButton.hidden = YES;
    if ( [entityObject canVote] || [entityObject canUnVote] ) {
        _likeButton.hidden = NO;
    }
}

- (BOOL)shouldUpdateCellWithObject:(AKEntityCellObject*)cellObject
{
    [super shouldUpdateCellWithObject:cellObject];
    
    AKEntityObject *entityObject = cellObject.entityObject;
    
    [self setCellThumbnail:entityObject];
    [self setCellTitle:entityObject];
    [self setCellBody:entityObject];
    [self setCellActions:entityObject];
  
    return YES;
}

+ (AKMediumCellEntityMetrics)entityMetrics:(id)entity constrainedToContentWidth:(CGFloat)contentWidth
        cellWidth:(CGFloat)cellWidth
{
    AKMediumCellEntityMetrics metrics = {0,0};
    
    if ( [entity conformsToProtocol:@protocol(AKPortriableBehavior)] ) {
        metrics.mediaHeight = 300;
    } 
    else {
        NSString* text = [entity body];
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]
                    constrainedToSize:CGSizeMake(contentWidth, INT_MAX)
                    lineBreakMode:NSLineBreakByCharWrapping
                    ];
        metrics.textHeight = size.height;
    }
    
    return metrics;
}

+ (CGFloat)heightForEntityObject:(id)entityObject
            atIndexPath:(NSIndexPath *)indexPath
            tableView:(UITableView *)tableView

{
    AKMediumCellElementMetrics metrics = [[self class] cellElementsMetrics];
    
    CGFloat totalPaddingRight = metrics.cellPadding.right + metrics.contentPadding.right;
    CGFloat totalPaddingLeft  = metrics.cellPadding.left + metrics.contentPadding.left;
    CGFloat constraintedWidth = tableView.frame.size.width - totalPaddingRight - totalPaddingLeft;
    
    AKMediumCellEntityMetrics entityMetrics = 
        [self entityMetrics:entityObject constrainedToContentWidth:constraintedWidth cellWidth:tableView.frame.size.width];

    CGFloat contentHeight = entityMetrics.mediaHeight +
            entityMetrics.textHeight +
            AKMediumCellContentPaddingHeightForEntityMetrics(entityMetrics);
    return
           contentHeight +
           metrics.actionsBoxHeight + 
           metrics.avatarSize.height +
           metrics.contentPadding.top +    
           metrics.cellPadding.top + metrics.cellPadding.bottom +
           metrics.contentPadding.top + metrics.contentPadding.bottom;
}

+ (CGFloat)heightForObject:(AKEntityCellObject*)cellObject atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return [self heightForEntityObject:cellObject.entityObject atIndexPath:indexPath tableView:tableView];
}

#pragma mark - 
#pragma mark - NIAttributedLabelDelegate

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel
            didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    NSNotification *notification = NULL;
    
    if ( [result.object isKindOfClass:[NSNotification class]] ) {
        notification = result.object;
    }
    //url is touched, lets create show url notification
    else if ( result.URL ) {
        notification = [NSNotification notificationWithName:kAKViewDidSelectURLNotification object:result.URL];
    }
    
    
    if ( NULL != notification ) {
        
        if ( self.notificationDelegate ) {
            [self.notificationDelegate view:self didPostNotification:notification];
        }
        
        //dispatch the notification
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end

#pragma mark -

@implementation AKMediumObjectDetailViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

+ (AKMediumCellEntityMetrics)entityMetrics:(id)entity constrainedToContentWidth:(CGFloat)contentWidth cellWidth:(CGFloat)cellWidth
{
    AKMediumCellEntityMetrics metrics = {0,0};
    
    if ( [entity conformsToProtocol:@protocol(AKPortriableBehavior)] ) {
        CGSize size = [[entity imageURL] imageSizeForSizeName:kAKMediumImageURL];        
        metrics.mediaHeight =  cellWidth * ((size.height == 0 ? size.width : size.height) / size.width);
    }
    
    NSString* text = [entity body];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]
                    constrainedToSize:CGSizeMake(contentWidth, INT_MAX)
                    lineBreakMode:NSLineBreakByCharWrapping
                    ];
    metrics.textHeight = size.height;
    
    return metrics;
}

- (void)setCellBody:(id)entityObject
{
    if ( [entityObject conformsToProtocol:@protocol(AKPortriableBehavior)]) {
        self.contentImageView.hidden = NO;
        NSURL *imageURL = [[entityObject imageURL] imageURLWithImageSize:kAKMediumImageURL];
        [self.contentImageView setImageWithURL:imageURL];
    }
    self.bodyLabel.hidden = NO;
    self.bodyLabel.text   = [entityObject body];
}

@end

#pragma mark - 

@implementation AKStoryObjectCell


- (void)setCellThumbnail:(AKStoryObject*)story
{
    AKActorObject *actorObject = story.subject;
    
    if ( [story.object conformsToProtocol:@protocol(AKOwnableBehavior)] ) {
        if ( [story.object owner] && [story.object owner].administratorIds != nil ) {
            actorObject = [story.object owner];
        }
    }
    
    NSURL *url = [actorObject.imageURL imageURLWithImageSize:kAKSquareImageURL];
    if ( url ) {
        [self.imageView setImageWithURL:url placeholderImage:kAKDefaultAvatarImage];
    } else {
       
    }
}

- (void)setCellTitle:(AKStoryObject*)story
{
    AKActorObject *actorObject = story.subject;
    
    if ( [story.name isEqualToString:@"actor_follow"] ) {
        NSString *title;
        
        if ( story.target ) {
            id link1 = AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:story.subject],
                    story.subject.name);
            id link2 = AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:story.target],
                    story.target.name);
            
            title = [NSString stringWithFormat:@"%@ is following %@", link1, link2];
        }
        else if ( story.targets ) {
            id link1 = AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:story.subject],
                    story.subject.name);
            id link2 = AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:story.targets],
                    [NSString stringWithFormat:@"%d others",story.targets.count]);
            
            title = [NSString stringWithFormat:@"%@ is following %@", link1, link2];        
        }
        
        self.titleLabel.text  = title;
        return;
    }
    
    if ( [story.object conformsToProtocol:@protocol(AKOwnableBehavior)] ) {
        if ( [story.object owner] && [story.object owner].administratorIds != nil ) {
            actorObject = [story.object owner];
        }
    }
    
    if ( actorObject ) {
         self.titleLabel.text  = [NSString stringWithFormat:@"%@",
            AKLinkTagFromObject(
                [NSNotification notificationWithName:kAKViewDidSelectViewObjectInDetailNotification object:actorObject],
                    actorObject.name)
            ];       

    }    
}

- (void)layoutContentForEntity:(AKStoryObject*)entity
{
    [super layoutContentForEntity:entity.object];
}

- (void)setCellBody:(AKStoryObject*)entityObject
{
    [super setCellBody:entityObject.object];
}

+ (CGFloat)heightForEntityObject:(AKStoryObject *)entityObject atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return [super heightForEntityObject:entityObject.object atIndexPath:indexPath tableView:tableView];
}

@end


#pragma mark -

@implementation AKButtonCellObject

- (Class)cellClass
{
    return [AKButtonCell class];
}

@end

@implementation AKButtonCell
{
    CAGradientLayer *_gradientLayer;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.backgroundView  = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectInset(self.contentView.frame, 3,0);
//    CAGradientLayer *gradientLayer = [self.contentView.layer.sublayers objectAtIndex:0];
//    gradientLayer.frame = self.contentView.bounds;
//    [self.contentView setClipsToBounds:YES];
    self.contentView.layer.cornerRadius = 5;
    self.selectedBackgroundView.frame = self.contentView.frame;
}

- (BOOL)shouldUpdateCellWithObject:(AKButtonCellObject*)object
{
    self.textLabel.text = object.title;
    UIColor *color = HEXCOLOR(0xE6E6E6);
    UIColor *textColor = HEXCOLOR(0x333333);
    self.imageView.image = object.image;
    self.textLabel.textColor = textColor;
    self.contentView.backgroundColor = color;
    self.contentView.layer.shadowColor  = AKDarkenUIColor(color,1).CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.contentView.layer.shadowRadius = 0.5;
    self.contentView.layer.shadowOpacity = 0.9;    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return YES;
}


//+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
//{
//
//}

@end