//
//  BATRecommendUserTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRecommendUserTableViewCell.h"
#import "BATRecommendUserModel.h"
#import "BATLoginModel.h"

@implementation BATRecommendUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.height / 2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _userNameLabel.textColor = UIColorFromHEX(0x333333, 1);
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    
    _signatureLabel.textColor = UIColorFromHEX(0x666666, 1);
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 3.0;
    _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
    [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    _followButton.layer.borderWidth = 1.0;
    
    [_followButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
    
    WEAK_SELF(self)
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self)
        make.left.right.bottom.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
    }];

}

-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _bottomView;
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
    
    if (recommendUserData.Sex == 0) {
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_girl"];
    }else {
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_man"];
    }
    
    _userNameLabel.text = recommendUserData.UserName;
    
    _signatureLabel.text = recommendUserData.Signature.length > 0 ? recommendUserData.Signature : @"这个家伙很懒，什么都没有留下。";
    
    [_followButton setTitle:(recommendUserData.IsFollowed ? @"已关注" : @"+ 关注") forState:UIControlStateNormal];
    
    if (recommendUserData.IsFollowed) {
        _followButton.layer.borderColor = BASE_COLOR.CGColor;
        [_followButton setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }else {
        _followButton.layer.borderColor = UIColorFromHEX(0xfc9f26, 1).CGColor;
        [_followButton setTitleColor:UIColorFromHEX(0xfc9f26, 1) forState:UIControlStateNormal];
    }
    
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
