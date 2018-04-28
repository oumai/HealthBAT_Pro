//
//  BATPunchCardTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPunchCardTableViewCell.h"

@implementation BATPunchCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.leftLabel];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.dayLabel];
    
    WEAK_SELF(self);
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(35, 35));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatorImageView.mas_right).offset(10);
        make.centerY.equalTo(self.avatorImageView.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.avatorImageView.mas_bottom).offset(10);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.top.bottom.equalTo(self.bgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.leftLabel.mas_right);
        make.top.bottom.equalTo(self.bgView);
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.titleLabel.mas_right);
        make.top.bottom.equalTo(self.bgView);
    }];
}

#pragma mark - get & set
- (UIImageView *)avatorImageView
{
    if (_avatorImageView == nil) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 35 / 2;
        _avatorImageView.layer.masksToBounds = YES;
    }
    return _avatorImageView;
}

- (UILabel *)userNameLabel
{
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:14];
        _userNameLabel.textColor = STRING_DARK_COLOR;
    }
    return _userNameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = STRING_LIGHT_COLOR;
    }
    return _timeLabel;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _bgView;
}

- (UILabel *)leftLabel
{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textColor = STRING_DARK_COLOR;
        [_leftLabel sizeToFit];
    }
    return _leftLabel;
}

- (BATGraditorButton *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[BATGraditorButton alloc]init];
        _titleLabel.enablehollowOut = YES;
        [_titleLabel setGradientColors:@[START_COLOR,END_COLOR]];
        _titleLabel.enbleGraditor = YES;
        _titleLabel.titleLabel.font = [UIFont systemFontOfSize:13];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)dayLabel
{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont systemFontOfSize:13];
        _dayLabel.textColor = STRING_DARK_COLOR;
        [_dayLabel sizeToFit];
    }
    return _dayLabel;
}

@end
