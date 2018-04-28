//
//  BATProgramDetailHeaderView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramDetailHeaderView.h"

@implementation BATProgramDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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

#pragma mark - Action
- (void)joinProgramButtonAction:(UIButton *)button
{
    if (self.joinProgramBlock) {
        self.joinProgramBlock();
    }
}

- (void)executePointsButtonAction:(UIButton *)button
{
    if (self.executePointsBlock) {
        self.executePointsBlock();
    }
}

- (void)pageLayout
{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.joinProgramButton];
    [self addSubview:self.executePointsButton];
//    self.bgView.backgroundColor = [UIColor redColor];
//    self.titleLabel.backgroundColor = [UIColor yellowColor];
//    self.countLabel.backgroundColor = [UIColor blueColor];
//    self.joinProgramButton.backgroundColor = [UIColor greenColor];
//    self.executePointsButton.backgroundColor = [UIColor grayColor];
    
    
    WEAK_SELF(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(SCREEN_WIDTH - 20);
        make.bottom.mas_equalTo(self.countLabel.mas_top).offset(-10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(SCREEN_WIDTH - 20);
    make.bottom.mas_equalTo(self.executePointsButton.mas_top).offset(-20);
    }];
    
    [self.joinProgramButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.top.equalTo(self.countLabel.mas_bottom).offset(35);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 20, 50));
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.executePointsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(100, 50));
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:27.5];
        _titleLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (BATGraditorButton *)joinProgramButton
{
    if (_joinProgramButton == nil) {
        _joinProgramButton = [[BATGraditorButton alloc]init];
        _joinProgramButton.titleColor = [UIColor whiteColor];
        _joinProgramButton.enablehollowOut = YES;
        [_joinProgramButton setGradientColors:@[START_COLOR,END_COLOR]];
        [_joinProgramButton setTitle:@"加入方案" forState:UIControlStateNormal];
        [_joinProgramButton addTarget:self action:@selector(joinProgramButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _joinProgramButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _joinProgramButton.layer.cornerRadius = 6.0f;
        _joinProgramButton.layer.masksToBounds = YES;
    }
    return _joinProgramButton;
}

- (UIButton *)executePointsButton
{
    if (_executePointsButton == nil) {
        _executePointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_executePointsButton setTitle:@"  执行要点" forState:UIControlStateNormal];
        [_executePointsButton setImage:[UIImage imageNamed:@"Follow_zxyd"] forState:UIControlStateNormal];
        _executePointsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_executePointsButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_executePointsButton addTarget:self action:@selector(executePointsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _executePointsButton.hidden = YES;
    }
    return _executePointsButton;
}

@end
