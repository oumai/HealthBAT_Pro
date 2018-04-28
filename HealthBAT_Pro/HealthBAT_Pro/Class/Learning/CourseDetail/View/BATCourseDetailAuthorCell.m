//
//  BATCourseDetailAuthorCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseDetailAuthorCell.h"

@implementation BATCourseDetailAuthorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
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

#pragma mark - Action
- (void)followButtonAction:(UIButton *)button
{
    if (self.followAction) {
        self.followAction();
    }
}

- (void)configData:(BATCourseDetailModel *)courseDetailModel;
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:courseDetailModel.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    self.usernameLabel.text = courseDetailModel.Data.TeacherName;
    self.decsLabel.text = courseDetailModel.Data.Signature;
    
    if (courseDetailModel.Data.IsFocus) {
        self.followButton.selected = YES;
        _followButton.layer.borderWidth = 0;
    } else {
        self.followButton.selected = NO;
        _followButton.layer.borderWidth = 1;
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.decsLabel];
    [self.contentView addSubview:self.followButton];
    
    WEAK_SELF(self);
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.followButton.mas_left).offset(-13);
    }];
    
    [self.decsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.equalTo(self.followButton.mas_left).offset(-13);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
    
}

#pragma mark - get & set
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 51 / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        _usernameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _usernameLabel;
}

- (UILabel *)decsLabel
{
    if (_decsLabel == nil) {
        _decsLabel = [[UILabel alloc] init];
        _decsLabel.textColor = UIColorFromHEX(0x666666, 1);
        _decsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _decsLabel;
}

- (UIButton *)followButton
{
    if (_followButton == nil) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
        [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_followButton setTitleColor:UIColorFromHEX(0xcecece, 1) forState:UIControlStateSelected];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];

        _followButton.layer.masksToBounds = YES;
        _followButton.layer.cornerRadius = 3.0;
        _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
        _followButton.layer.borderWidth = 1.0;
        
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _followButton;
}

@end
