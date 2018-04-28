//
//  BATRecommendDoctorTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRecommendDoctorTableViewCell.h"
#import "BATRecommendUserModel.h"
#import "BATLoginModel.h"

@implementation BATRecommendDoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 5.0;
    _followButton.layer.borderColor = BASE_COLOR.CGColor;
    _followButton.layer.borderWidth = 1.0;
    
    [_followButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configrationCell:(id)model
{
    BATRecommendUserData *recommendUserData = (BATRecommendUserData *)model;
    
    if([recommendUserData.PhotoPath hasPrefix:@"http://"]){
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommendUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    }else{
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,recommendUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
    }


    
    _userNameLabel.text = recommendUserData.UserName;
    
    _signatureLabel.text = recommendUserData.Signature.length > 0 ? recommendUserData.Signature : @"这个家伙很懒，什么都没有留下。";
    
    _masterImageView.hidden = !recommendUserData.IsMaster;
    
    _sexImageView.image = recommendUserData.Sex == 0 ? [UIImage imageNamed:@"icon_sex_man"] : [UIImage imageNamed:@"icon_sex_girl"];
    
    [_followButton setTitle:(recommendUserData.IsFollowed ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
    
    BATLoginModel *loginModel = LOGIN_INFO;
    
    if (recommendUserData.AccountID == loginModel.Data.ID) {
        //判断是否是当前登陆账号，是就hidden followButton
        _followButton.hidden = YES;
    } else {
        _followButton.hidden = NO;
    }
}

#pragma mark - Action

#pragma mark - 关注操作
- (void)followButton:(UIButton *)button
{
    if (self.followUser) {
        self.followUser();
    }
}

@end
