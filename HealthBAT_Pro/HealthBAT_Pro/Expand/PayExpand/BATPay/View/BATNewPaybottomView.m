//
//  BATNewPaybottomView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPaybottomView.h"

@implementation BATNewPaybottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [self addSubview:self.confirmPayBtn];
    [self.confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(35);
        make.width.equalTo(self.mas_width).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(40);
    }];

    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.confirmPayBtn.mas_bottom).offset(20);
        make.left.equalTo(self.confirmPayBtn);
    }];
    
    [self addSubview:self.deseLabel];
    [self.deseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}



- (UILabel *)titleLabel{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
        _titleLable.text = @"买前必读";
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}

- (UILabel *)deseLabel{
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _descLabel.text = @"1、请在预约时间段内，通过就医订单进入诊室至呼叫医生，若预约时间段内呼叫医生没接通，自动退款返还至您的账户\n\n2、订单15分钟之内未支付，会取消";
        _descLabel.numberOfLines = 0;
        [_descLabel sizeToFit];
    }
    
    return _descLabel;
}



- (BATGraditorButton *)confirmPayBtn{
    if (!_confirmPayBtn) {
        _confirmPayBtn = [[BATGraditorButton alloc] init];
        [_confirmPayBtn setTitle:@"确认支付" forState:UIControlStateNormal] ;
        _confirmPayBtn.enablehollowOut = YES;
        _confirmPayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _confirmPayBtn.titleColor = [UIColor whiteColor];
        [_confirmPayBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _confirmPayBtn.layer.cornerRadius = 6.0f;
        _confirmPayBtn.layer.masksToBounds = YES;
    }
    
    return _confirmPayBtn;
}

@end
