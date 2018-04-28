//
//  BATCourseDetailBottomView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseDetailBottomView.h"

@implementation BATCourseDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
        
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
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
- (void)buttonAction:(UIButton *)button
{
    if (self.inputBlock) {
        self.inputBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.bgView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.button];
    
    WEAK_SELF(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.left.equalTo(self.bgView.mas_left).offset(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = (1.0f / [UIScreen mainScreen].scale);
        _bgView.layer.borderColor = [UIColor grayColor].CGColor;
        _bgView.layer.cornerRadius = 15;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"ic-xpl"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"写评论...";
        _titleLabel.textColor = UIColorFromHEX(0x999999, 1);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
