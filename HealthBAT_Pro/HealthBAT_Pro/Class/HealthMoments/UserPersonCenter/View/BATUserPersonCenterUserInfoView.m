//
//  BATUserPersonCenterUserInfoView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATUserPersonCenterUserInfoView.h"
#import "BATPerson.h"
#import "BATLoginModel.h"

@implementation BATUserPersonCenterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BASE_COLOR;
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = 50;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
        
        _masterImageView = [[UIImageView alloc] init];
        [self addSubview:_masterImageView];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:19];
        _userNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_userNameLabel];
        
        _sexImageView = [[UIImageView alloc] init];
        [self addSubview:_sexImageView];
        
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.numberOfLines = 2;//设置为两行
        _signatureLabel.textColor = [UIColor whiteColor];
        _signatureLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_signatureLabel];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.backgroundColor = UIColorFromRGB(250, 140, 32,1);
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followButton setTintColor:[UIColor whiteColor]];
        _followButton.hidden = YES;
        [self addSubview:_followButton];
        
        _consulationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _consulationButton.backgroundColor = UIColorFromRGB(14, 109, 158,1);
        [_consulationButton setTitle:@"咨询" forState:UIControlStateNormal];
        [_consulationButton addTarget:self action:@selector(consulationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _consulationButton.hidden = YES;
        [self addSubview:_consulationButton];
        
        _toolView = [[UIView alloc] init];
        //        _toolView.backgroundColor = UIColorFromRGB(238.0, 238.0, 238.0, 1.0f);
        _toolView.backgroundColor = BASE_COLOR;
        _toolView.layer.borderColor = _toolView.backgroundColor.CGColor;
        _toolView.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
        [self addSubview:_toolView];
        
        _followMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _followMemberButton.backgroundColor = [UIColor whiteColor];
        [_followMemberButton setBackgroundImage:[UIImage imageNamed:@"personalCenter_menuBg"] forState:UIControlStateNormal];
        [_followMemberButton setTitle:@"0 关注" forState:UIControlStateNormal];
        _followMemberButton.titleLabel.font = [UIFont systemFontOfSize:14];
        //        [_followMemberButton setTitleColor:UIColorFromRGB(103, 103, 103,1) forState:UIControlStateNormal];
        [_followMemberButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_toolView addSubview:_followMemberButton];
        
        _fansMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _fansMemberButton.backgroundColor = [UIColor whiteColor];
        [_fansMemberButton setBackgroundImage:[UIImage imageNamed:@"personalCenter_menuBg"] forState:UIControlStateNormal];
        [_fansMemberButton setTitle:@"0 粉丝" forState:UIControlStateNormal];
        _fansMemberButton.titleLabel.font = [UIFont systemFontOfSize:14];
        //        [_fansMemberButton setTitleColor:UIColorFromRGB(103, 103, 103,1) forState:UIControlStateNormal];
        [_fansMemberButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_toolView addSubview:_fansMemberButton];
        
        [self setupConstraints];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [_masterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.bottom.equalTo(_avatarImageView.mas_bottom);
        make.right.equalTo(_avatarImageView.mas_right).offset(-10);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(_avatarImageView.mas_top);
        make.height.mas_equalTo(21);
    }];
    
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(_userNameLabel.mas_centerY);
        make.right.greaterThanOrEqualTo(self.mas_right).offset(-30).priorityLow();
        make.left.equalTo(_userNameLabel.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(8);
        //        make.height.mas_equalTo(21);
        make.right.equalTo(self.mas_right).offset(-30);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.bottom.equalTo(_avatarImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [_consulationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_followButton.mas_right).offset(10);
        make.bottom.equalTo(_followButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [_followMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(_toolView);
        make.width.mas_equalTo((SCREEN_WIDTH - 0.5) / 2);
    }];
    
    [_fansMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(_toolView);
        make.width.mas_equalTo((SCREEN_WIDTH - 0.5) / 2);
    }];
    
}

#pragma mark - Action

#pragma mark - 配置加载数据
- (void)configrationUserInfo:(id)model
{
    BATPerson *person = (BATPerson *)model;
    
    //头像
    if([person.Data.PhotoPath hasPrefix:@"http://"]){
        //        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            if (image) {
        //                _avatarImageView.image = [Tools findFace:image];
        //            }
        //        }];
        
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
    }else{
        //        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, person.Data.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            if (image) {
        //                _avatarImageView.image = [Tools findFace:image];
        //            }
        //        }];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APP_WEB_DOMAIN_URL, person.Data.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
    }
    
    //等级
    if (person.Data.IsMaster == 1) {
        _masterImageView.hidden = NO;
        
        if (person.Data.AccountType == 2) {
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

    //用户名
    _userNameLabel.text = person.Data.UserName;
    
    //性别
    if([person.Data.Sex isEqualToString:@"1"]){
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_man"];
    } else {
        _sexImageView.image = [UIImage imageNamed:@"icon_sex_girl"];
    }
    
    //个性签名
    _signatureLabel.text = person.Data.Signature.length > 0 ? person.Data.Signature : @"这个家伙很懒，什么都没有留下。";
    
    _followButton.hidden = NO;
    //关注操作按钮
    if (person.Data.IsFollowed) {
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        _followButton.backgroundColor = UIColorFromHEX(0xffffff, 0.2);
    } else {
        [_followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        _followButton.backgroundColor = UIColorFromRGB(250, 140, 32, 1);
    }
    
    //    //咨询操作按钮
    //    if (person.Data.AccountType == 1) {
    //        _consulationButton.hidden = YES;
    //    } else {
    //        _consulationButton.hidden = NO;
    //    }
    
    
    //关注人数
    [_followMemberButton setAttributedTitle:[self menuUnNomalBtnString:[NSString stringWithFormat:@"关注 %ld",(long)person.Data.FollowNum]] forState:UIControlStateNormal];
    //    [_followMemberButton setTitle:[NSString stringWithFormat:@"%ld 关注",(long)person.Data.GuanZhuCount] forState:UIControlStateNormal];
    
    //粉丝数
    [_fansMemberButton setAttributedTitle:[self menuUnNomalBtnString:[NSString stringWithFormat:@"粉丝 %ld",(long)person.Data.FansNum]] forState:UIControlStateNormal];
    //    [_fansMemberButton setTitle:[NSString stringWithFormat:@"%ld 粉丝",(long)person.Data.FansCount] forState:UIControlStateNormal];
    
    
    //判断只有在查看是当前登录用户时，才可以点击关注人数或者粉丝数查看人员列表
    BATLoginModel *loginModel = LOGIN_INFO;
    
    if (person.Data.AccountID == loginModel.Data.ID) {
        
        [_userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImageView.mas_centerY);
            make.left.equalTo(_avatarImageView.mas_right).offset(10);
            make.height.mas_equalTo(21);
        }];
        
        [self layoutIfNeeded];
        
        _followButton.hidden = YES;
        _consulationButton.hidden = YES;
        
        [_followMemberButton addTarget:self action:@selector(followMemberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fansMemberButton addTarget:self action:@selector(fansMemberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}

#pragma mark - 头像点击
- (void)tapHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //    [SJAvatarBrowser showImage:_avatarImageView];
}

#pragma mark - 关注或者取消关注
- (void)followButtonAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(BATUserPersonCenterUserInfoView:followButtonClicked:)]) {
        [_delegate BATUserPersonCenterUserInfoView:self followButtonClicked:button];
    }
}

#pragma mark - 咨询
- (void)consulationButtonAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(BATUserPersonCenterUserInfoView:consulationButtonClicked:)]) {
        [_delegate BATUserPersonCenterUserInfoView:self consulationButtonClicked:button];
    }
}

#pragma mark - 关注成员
- (void)followMemberButtonAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(BATUserPersonCenterUserInfoView:followMemberButtonClicked:)]) {
        [_delegate BATUserPersonCenterUserInfoView:self followMemberButtonClicked:button];
    }
}

#pragma mark - 粉丝成员
- (void)fansMemberButtonAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(BATUserPersonCenterUserInfoView:fansMemberButtonClicked:)]) {
        [_delegate BATUserPersonCenterUserInfoView:self fansMemberButtonClicked:button];
    }
}

#pragma mark - private
- (NSMutableAttributedString *)menuNomalBtnString:(NSString *)stirng
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stirng];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSMutableAttributedString *)menuUnNomalBtnString:(NSString *)stirng
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stirng];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
    
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(3, attributedString.length - 3)];
    return attributedString;
}

@end
