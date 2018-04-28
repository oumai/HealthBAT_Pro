//
//  BATMyFollowTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFollowTableViewCell.h"
#import "BATMyFollowUserModel.h"
#import "BATLoginModel.h"

@implementation BATMyFollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
//    _followButton.layer.masksToBounds = YES;
//    _followButton.layer.cornerRadius = 5.0;
//    _followButton.layer.borderColor = BASE_COLOR.CGColor;
//    _followButton.layer.borderWidth = 1.0;
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 3.0;
    _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
    [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    _followButton.layer.borderWidth = 1.0;
    
    [_followButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configrationCell:(id)model
{
    BATMyFollowUserData *myFollowUserData = (BATMyFollowUserData *)model;
    
    if ([myFollowUserData.PhotoPath hasPrefix:@"http://"]) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:myFollowUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
    } else {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,myFollowUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"用户"]];
    }
    
    
    _userNameLabel.text = myFollowUserData.UserName;
    
    _signatureLabel.text = myFollowUserData.Signature.length > 0 ? myFollowUserData.Signature : @"这个家伙很懒，什么都没有留下。";
    
    //等级
    if (myFollowUserData.IsMaster == 1) {
        _masterImageView.hidden = NO;
        
        if (myFollowUserData.AccountType == 2) {
            //医生
            _masterImageView.image = [UIImage imageNamed:@"icon_level_doctor"];
        } else {
            //用户
            _masterImageView.image = [UIImage imageNamed:@"icon_level"];
        }
    } else {
        _masterImageView.hidden = YES;
    }
    _masterImageView.hidden = YES;

    _sexImageView.image = myFollowUserData.Sex == 1 ? [UIImage imageNamed:@"icon_sex_man"] : [UIImage imageNamed:@"icon_sex_girl"];
    
    [_followButton setTitle:(myFollowUserData.IsFollowed ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
    
    if (!myFollowUserData.IsFollowed) {
        _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
        [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    }else {
        _followButton.layer.borderColor = BASE_COLOR.CGColor;
        [_followButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }
    
    BATLoginModel *loginModel = LOGIN_INFO;
    
    if (myFollowUserData.AccountID == loginModel.Data.ID) {
        //判断是否是当前登陆账号，是就hidden followButton
        _followButton.hidden = YES;
    } else {
        _followButton.hidden = NO;
    }
}

#pragma makr - Action

#pragma mark - 关注操作
- (void)followButton:(UIButton *)button
{
    if (self.followUser) {
        self.followUser();
    }
}

@end
