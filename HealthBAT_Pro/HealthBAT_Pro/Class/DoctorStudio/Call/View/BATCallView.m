//
//  BATCallView.m
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "BATCallView.h"

@implementation BATCallView

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

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.bgView];
    [self addSubview:self.avatarBgView];
    [self.avatarBgView addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.doctorTitleLabel];
    [self addSubview:self.hospitalAndDepartmentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.callStateLabel];
//    [self addSubview:self.networkStateView];
    [self addSubview:self.cancelButton];
    [self addSubview:self.hangUpButton];
    [self addSubview:self.answerButton];
    [self addSubview:self.waterLine];
    
    WEAK_SELF(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.avatarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(100, 100));
        make.top.equalTo(self.mas_top).offset(80);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBgView);
        make.size.mas_offset(CGSizeMake(98, 98));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.avatarBgView.mas_bottom).offset(15);
    }];
    
    [self.doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    
    [self.hospitalAndDepartmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.doctorTitleLabel.mas_bottom).offset(15);
    }];
    
    
    [self.callStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.hospitalAndDepartmentLabel.mas_bottom).offset(23);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.hospitalAndDepartmentLabel.mas_bottom).offset(23);
    }];
    
    /*
    [self.networkStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.callStateLabel.mas_bottom).offset(21);
        make.left.right.equalTo(self);
        make.height.mas_offset(22);
    }];
    */
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.mas_bottom).offset(-58.5);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(60, 100));
    }];
    
    
    CGFloat offsetX = (SCREEN_WIDTH - 60 * 2 - 104.5) / 2;
    
    [self.hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.mas_bottom).offset(-58.5);
        make.size.mas_offset(CGSizeMake(60, 100));
        make.left.equalTo(self.mas_left).offset(offsetX);
    }];
    
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.bottom.equalTo(self.mas_bottom).offset(-58.5);
        make.size.mas_offset(CGSizeMake(60, 100));
        make.left.equalTo(self.hangUpButton.mas_right).offset(104.5);
        make.right.equalTo(self.mas_right).offset(-offsetX);
    }];
    
    [self.waterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-50);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - get & set
- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"VAA-bg"];
    }
    return _bgView;
}

- (UIView *)avatarBgView
{
    if (_avatarBgView == nil) {
        _avatarBgView = [[UIView alloc] init];
        _avatarBgView.backgroundColor = [UIColor whiteColor];
        _avatarBgView.layer.cornerRadius = 100 / 2;
        _avatarBgView.layer.masksToBounds = YES;
    }
    return _avatarBgView;
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 98 / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)callStateLabel
{
    if (_callStateLabel == nil) {
        _callStateLabel = [[UILabel alloc] init];
        _callStateLabel.font = [UIFont systemFontOfSize:18];
        _callStateLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _callStateLabel.backgroundColor = [UIColor clearColor];
        _callStateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _callStateLabel;
}

- (UILabel *)doctorTitleLabel
{
    if (_doctorTitleLabel == nil) {
        _doctorTitleLabel = [[UILabel alloc] init];
        _doctorTitleLabel.font = [UIFont systemFontOfSize:18];
        _doctorTitleLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _doctorTitleLabel.backgroundColor = [UIColor clearColor];
        _doctorTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _doctorTitleLabel;
}

- (UILabel *)hospitalAndDepartmentLabel
{
    if (_hospitalAndDepartmentLabel == nil) {
        _hospitalAndDepartmentLabel = [[UILabel alloc] init];
        _hospitalAndDepartmentLabel.font = [UIFont systemFontOfSize:18];
        _hospitalAndDepartmentLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _hospitalAndDepartmentLabel.backgroundColor = [UIColor clearColor];
        _hospitalAndDepartmentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hospitalAndDepartmentLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:18];
        _timeLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

/*
- (BATNetworkStateView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[BATNetworkStateView alloc] init];
        _networkStateView.backgroundColor = [UIColor clearColor];
        _networkStateView.hidden = YES;
    }
    return _networkStateView;
}
*/
- (BATCallOptButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [[BATCallOptButton alloc] init];
        _cancelButton.titleLabel.text = @"取消";
        _cancelButton.imageView.image = [UIImage imageNamed:@"VAA-qx"];
    }
    return _cancelButton;
}

- (BATCallOptButton *)hangUpButton
{
    if (_hangUpButton == nil) {
        _hangUpButton = [[BATCallOptButton alloc] init];
        _hangUpButton.titleLabel.text = @"挂断";
        _hangUpButton.imageView.image = [UIImage imageNamed:@"VAA-qx"];
    }
    return _hangUpButton;
}


- (BATCallOptButton *)answerButton
{
    if (_answerButton == nil) {
        _answerButton = [[BATCallOptButton alloc] init];
        _answerButton.titleLabel.text = @"接听";
        _answerButton.imageView.image = [UIImage imageNamed:@"VAA-jt"];
    }
    return _answerButton;
}

- (BATWaterLine *)waterLine{
    if (!_waterLine) {
        _waterLine = [[BATWaterLine alloc]init];
    }
    return _waterLine;
}


@end
