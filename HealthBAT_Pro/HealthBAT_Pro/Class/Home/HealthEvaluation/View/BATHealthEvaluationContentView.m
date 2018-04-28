
//
//  BATHealthEvaluationContentView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthEvaluationContentView.h"

@interface BATHealthEvaluationContentView ()

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *line;

@end

@implementation BATHealthEvaluationContentView

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

#pragma mark - Action
- (void)closeBtnAction:(UIButton *)button
{
    if (self.closeContentBlock) {
        self.closeContentBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.control];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.contentLabel];
    
    WEAK_SELF(self);
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 200));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.top.equalTo(self.bgView.mas_top).offset(25);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(20, 20));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.bgView);
        make.height.mas_offset((1.0f / [UIScreen mainScreen].scale));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
//        make.bottom.greaterThanOrEqualTo(self.bgView.mas_bottom).offset(-10);
    }];
}

#pragma mark - get & set
- (UIControl *)control
{
    if (_control == nil) {
        _control = [[UIControl alloc] init];
        _control.backgroundColor = [UIColor blackColor];
        _control.alpha = 0.5f;
    }
    return _control;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
    }
    return _titleLabel;
}

- (UILabel *)line
{
    if (_line == nil) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = UIColorFromHEX(0xeeeeee, 1);
    }
    return _line;
}

- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon-gbb"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.textColor = [UIColor blackColor];
//        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

@end
