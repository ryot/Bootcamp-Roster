//
//  RTTableViewCell.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/11/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTTableViewCell.h"
#import "RTViewController.h"
#import "RTCellColorGradientView.h"

@interface RTTableViewCell ()

@property (nonatomic, strong) UIImageView *personPic;
@property (nonatomic, strong) UILabel *fullNameLabel;
@property (nonatomic, strong) UILabel *githubLabel;
@property (nonatomic, strong) UILabel *twitterLabel;
@property (nonatomic, strong) RTCellColorGradientView *gradientView;

@end

@implementation RTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        static float picSize = kCELL_HEIGHT * 0.8;
        _gradientView = [[RTCellColorGradientView alloc] initWithFrame:CGRectMake(0, 0, 320, kCELL_HEIGHT) andColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_gradientView];
        _personPic = [[UIImageView alloc] initWithFrame:CGRectMake(picSize/2, (kCELL_HEIGHT - picSize)/2, picSize, picSize)];
        _personPic.clipsToBounds = YES;
        _personPic.layer.cornerRadius = 5;
        _personPic.contentMode = UIViewContentModeScaleAspectFill;
        [_gradientView addSubview:_personPic];
        
        _fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCELL_HEIGHT * 2, 0, 160, kCELL_HEIGHT)];
        [self.contentView addSubview:_fullNameLabel];
        _twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, kCELL_HEIGHT * 0.1, 70, kCELL_HEIGHT/3)];
        _githubLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, kCELL_HEIGHT/2 + kCELL_HEIGHT * 0.1, 70, kCELL_HEIGHT/3)];
        _twitterLabel.font = [UIFont italicSystemFontOfSize:_twitterLabel.font.pointSize - 5];
        _githubLabel.font = [UIFont italicSystemFontOfSize:_githubLabel.font.pointSize - 5];
        _twitterLabel.textColor = [UIColor darkGrayColor];
        _githubLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_twitterLabel];
        [self.contentView addSubview:_githubLabel];
    }
    return self;
}

-(void)setPerson:(RTPerson *)person
{
    _person = person;
    _personPic.image = nil;
    if (_person.image) {
        _personPic.image = _person.image;
    }
    _fullNameLabel.text = _person.fullName;
    _twitterLabel.text = _person.twitter;
    _githubLabel.text = _person.github;
        
    _gradientView.color = _person.color;
    [_gradientView setNeedsDisplay];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
