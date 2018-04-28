//
//  BATCourseDetailHeaderView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseDetailHeaderView.h"

@interface BATCourseDetailHeaderView ()<ZFPlayerDelegate>

@end

@implementation BATCourseDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
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

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction
{
    
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
//    self.decsLabel.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    
    if (courseDetailModel.Data.IsFocus) {
        self.followButton.hidden = YES;
        self.followimageView.hidden = NO;
    } else {
        self.followButton.hidden = NO;
        self.followimageView.hidden = YES;
    }
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = courseDetailModel.Data.Topic;
    model.placeholderImageURLString = courseDetailModel.Data.Poster;
    model.videoURL = [NSURL URLWithString:courseDetailModel.Data.AttachmentUrl];
    model.fatherView = self.fatherView;
    
    self.controlView.testTitleLabel.text = courseDetailModel.Data.Theme;
    self.controlView.isTest = courseDetailModel.Data.IsTestTemplate;
    
    [self.playerView playerControlView:self.controlView playerModel:model];
    
    self.playerView.hasPreviewView = YES;
    
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.userInfoView];
    [self.userInfoView addSubview:self.avatarImageView];
    [self.userInfoView addSubview:self.usernameLabel];
    [self.userInfoView addSubview:self.decsLabel];
    [self.userInfoView addSubview:self.followButton];
    [self.userInfoView addSubview:self.followimageView];
    [self addSubview:self.fatherView];
    
    WEAK_SELF(self);
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 68));
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.userInfoView.mas_left).offset(15);
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.size.mas_offset(CGSizeMake(51, 51));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.userInfoView.mas_top).offset(15);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.userInfoView.mas_right).offset(-10);
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.size.mas_offset(CGSizeMake(65, 26));
    }];
    
    [self.followimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.userInfoView.mas_right).offset(-10);
        make.centerY.equalTo(self.userInfoView.mas_centerY);
        make.size.mas_offset(CGSizeMake(65, 26));
    }];
    
    
    [self.decsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.userInfoView.mas_bottom).offset(-15);
        make.right.equalTo(self.followButton.mas_left).offset(-13);
    }];
    

    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.userInfoView.mas_bottom);
    }];
    
}

#pragma mark - get & set

- (UIView *)userInfoView
{
    if (_userInfoView == nil) {
        _userInfoView = [[UIView alloc] init];
    }
    return _userInfoView;
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 51 / 2;
        _avatarImageView.layer.masksToBounds = YES;
        [_avatarImageView setUserInteractionEnabled:YES];
        WEAK_SELF(self);
        [_avatarImageView bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.avatarTap) {
                self.avatarTap();
            }
        }];
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.textColor = UIColorFromHEX(0x0182eb, 1);
        _usernameLabel.font = [UIFont systemFontOfSize:16];
        [_usernameLabel sizeToFit];
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

- (BATGraditorButton *)followButton
{
    if (_followButton == nil) {
        _followButton = [[BATGraditorButton alloc]init];
        [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
        [_followButton setGradientColors:@[START_COLOR,END_COLOR]];
        _followButton.clipsToBounds = YES;
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.layer.cornerRadius = 5.0;
        _followButton.hidden = YES;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _followButton;
}

- (UIImageView *)followimageView {

    if (!_followimageView) {
        _followimageView = [[UIImageView alloc]init];
        _followimageView.image = [UIImage imageNamed:@"icon-ygz-gray"];
        _followimageView.hidden = YES;
    }
    return _followimageView;
}

- (UIView *)fatherView
{
    if (_fatherView == nil) {
        _fatherView = [[UIView alloc] init];
        _fatherView.backgroundColor = [UIColor blackColor];
    }
    return _fatherView;
}

- (ZFPlayerView *)playerView
{
    if (_playerView == nil) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}


@end
