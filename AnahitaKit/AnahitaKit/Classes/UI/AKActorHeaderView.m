//
//  AKActorHeader.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKActorHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation AKActorHeaderView

- (id)initWithActor:(AKActorObject*)actorObject
{
    _actorObject = actorObject;
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.cornerRadius = 5;
        [_imageView setClipsToBounds:YES];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _metaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        
        _metaLabel.backgroundColor = [UIColor clearColor];
        _metaLabel.font = [UIFont systemFontOfSize:12];
        _metaLabel.textColor = HEXCOLOR(0x555555);
        
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = HEXCOLOR(0x000000);
        
        _followersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_followersBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchDown];
        
        
        [self addSubview:_followersBtn];
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:_metaLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.bounds = CGRectSetHeight(CGRectSetXY(self.superview.frame, 0, 0), 60);

    NSURL *url = [_actorObject.imageURL imageURLWithImageSize:kAKSquareImageURL];
    [_imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"vimeo.jpg"]];

    _nameLabel.text  = _actorObject.name;
    
    NSMutableString *labelText = [NSMutableString stringWithFormat:@"Followers: %d", _actorObject.followerCount.intValue];
    
    if ( [_actorObject respondsToSelector:@selector(leaderCount)] ) {
        [labelText appendFormat:@" | Leaders: %d", [((id)_actorObject) leaderCount].intValue];
    }

    UIImage *icon = kAKSocialGraphIconImage;
    CGRect rect = CGRectInset(self.bounds, 5, 5);
    NSArray *result = CGRectDivide2(rect,@[@60,@(CGRectGetWidth(self.bounds)-50-icon.size.width-40)], CGRectMinXEdge);
    
    _metaLabel.text = labelText;

    _imageView.frame    = CGRectSetWidthHeight([result[0] CGRectValue],50,50);
    _nameLabel.frame    = CGRectSetHeight([result[1] CGRectValue],25);
    _followersBtn.frame = CGRectInset(CGRectSetHeight([result[2] CGRectValue],50),5,5);
    _metaLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame),
                                    CGRectGetMaxY(_nameLabel.frame),
                                    CGRectGetWidth(_nameLabel.frame), 25);
    
//    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10,
//                                    0,
//                                    CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageView.frame),
//                                    30);
    

    CGRect box1, box2;
    
    CGRectDivide(CGRectSetHeight(CGRectSetY(self.frame, CGRectGetMaxY(_imageView.frame) + 10),80), &box1, &box2, CGRectGetWidth(self.frame) / 2, CGRectMinXEdge);
//    _followersBtn.frame = CGRectInset(box1, 10, 10);
    [_followersBtn setImage:kAKSocialGraphIconImage forState:UIControlStateNormal];
    [(UITableView *)self.superview setTableHeaderView:self];        
}

- (void)didSelectAction:(id)sender
{
    NSString *notificationName;

    notificationName = kAKViewDidSelectFollowersActionNotification;
    
    [self.notificationDelegate view:self didPostNotification:
        [NSNotification notificationWithName:notificationName object:self.actorObject]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
