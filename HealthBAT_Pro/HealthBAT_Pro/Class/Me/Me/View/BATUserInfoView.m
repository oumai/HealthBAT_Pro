//
//  UserInfoView.m
//  HealthBAT
//
//  Created by KM on 16/6/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATUserInfoView.h"
#import "WZLBadgeImport.h"

@interface BATUserInfoView ()

@property (nonatomic,strong) UIView *line;

@end

@implementation BATUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUserInteractionEnabled:YES];
        
        self.image = [UIImage imageNamed:@"personCenter_top_bg"];
        
        _bgView = [[UIImageView alloc] init];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        _avatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personCenter_user_icon"]];
        _avatorImageView.layer.borderWidth = 2.0f;
        _avatorImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatorImageView.layer.cornerRadius = 65*0.5;
        _avatorImageView.clipsToBounds = YES;
        _avatorImageView.userInteractionEnabled = YES;
        [_bgView addSubview:_avatorImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatorAction)];
        [_avatorImageView addGestureRecognizer:tap];
        
        _masterView = [[UIImageView alloc] init];
        _masterView.backgroundColor = [UIColor redColor];
        _masterView.image = [UIImage imageNamed:@"icon_level"];
        _masterView.hidden = YES;
        _masterView.backgroundColor = [UIColor whiteColor];
        _masterView.layer.cornerRadius = 5.0f;
        [_bgView addSubview:_masterView];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.hidden = YES;
        [_loginButton sizeToFit];
        [_bgView addSubview:_loginButton];
        
        _nickNameLabel = [[UILabel alloc] init];
        //        _nickNameLabel.font = [UIFont systemFontOfSize:15];
        //        _nickNameLabel.textColor = UIColorFromRGB(255, 255, 255, 1);
        _nickNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _nickNameLabel.textColor = UIColorFromHEX(0xffffff, 1);
        
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [_nickNameLabel sizeToFit];
        [_bgView addSubview:_nickNameLabel];
        
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _signatureLabel.textColor = UIColorFromHEX(0xffffff, 1);
        //        _signatureLabel.font = [UIFont systemFontOfSize:14];
        //        _signatureLabel.textColor = UIColorFromRGB(255, 255, 255, 1);
        _signatureLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _signatureLabel.numberOfLines = 0;
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_signatureLabel];
        
        _pencilImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personCenter_pen"]];
        _pencilImage.hidden = YES;
        [_bgView addSubview:_pencilImage];
        
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:nil Font:nil];
        [_messageButton setImage:[UIImage imageNamed:@"personCenter_Message"] forState:UIControlStateNormal];
        _messageButton.imageView.clipsToBounds = NO;
        _messageButton.imageView.badgeCenterOffset = CGPointMake(-4, 5);
        [_messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_messageButton];
        
        _userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_userInfoBtn addTarget:self action:@selector(userInfoAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_userInfoBtn];
        
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Action
- (void)avatorAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(showAvatorAction)]) {
        [_delegate showAvatorAction];
    }
}


- (void)messageAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(goMessageCenterAction)]) {
        [_delegate goMessageCenterAction];
    }
}

- (void)loginAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(goLoginAction)]) {
        [_delegate goLoginAction];
    }
}

- (void)userInfoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(goUserInfoAction)]) {
        [_delegate goUserInfoAction];
    }
}

#pragma mark - private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.bottom.right.equalTo(self);
    }];
    
    [_avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_bgView.mas_top).offset(94*0.5+20);
        make.size.mas_equalTo(CGSizeMake(130*0.5, 130*0.5));
    }];
    
    [_masterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatorImageView.mas_bottom);
        make.right.equalTo(_avatorImageView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_avatorImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(25);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_avatorImageView.mas_bottom).offset(15*0.5);
        make.height.mas_equalTo(20);
    }];
    
    [_pencilImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLabel.mas_right).offset(10);
        make.centerY.equalTo(_nickNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.lessThanOrEqualTo(_bgView.mas_right).offset(-30).priorityHigh();
    }];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    }];
    
    [_userInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(52+60).priorityHigh();
        make.left.bottom.right.equalTo(_bgView);
    }];
    
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(40);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    
}

- (void)configureWithModel:(BATPerson *)person {
    
    if (person == nil) {
        
        _loginButton.hidden = NO;
        _masterView.hidden = YES;
        _nickNameLabel.hidden = YES;
        _signatureLabel.hidden = YES;
        _messageButton.hidden = YES;
        _pencilImage.hidden = YES;
        _userInfoBtn.hidden = YES;
        _masterView.hidden = YES;
        
        [_avatorImageView setImage:[UIImage imageNamed:@"personCenter_user_icon"]];
    }
    else {
        _loginButton.hidden = YES;
        _masterView.hidden = YES;
        _nickNameLabel.hidden = NO;
        _signatureLabel.hidden = NO;
        _messageButton.hidden = NO;
        _pencilImage.hidden = YES; // 3.8取消
        _userInfoBtn.hidden = NO;
        
        [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
        if (person.Data.IsMaster == 1) {
            _masterView.hidden = NO;
            _masterView.image = [UIImage imageNamed:@"icon_level"];
        }
        else {
            _masterView.hidden = YES;
        }
        _masterView.hidden = YES;

        _nickNameLabel.text = person.Data.UserName;
        
        if ([person.Data.Signature length] > 0) {
            _signatureLabel.text = person.Data.Signature;
        }
        else {
            _signatureLabel.text = @"这个家伙很懒，什么都没有留下";
        }
        
        self.signatureLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
    }
    //个性签名不要
    _signatureLabel.hidden = YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark private

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
