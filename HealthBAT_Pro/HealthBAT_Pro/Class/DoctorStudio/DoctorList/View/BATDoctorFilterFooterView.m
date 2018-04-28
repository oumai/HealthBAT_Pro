//
//  BATDoctorFilterFooterView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorFilterFooterView.h"

@implementation BATDoctorFilterFooterView

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
- (void)confirmBtnAction:(UIButton *)button
{
    if (self.doctorFilterFooterConfrimBlock) {
        self.doctorFilterFooterConfrimBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.confrimButton];
    
    
    WEAK_SELF(self);
    [self.confrimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(150, 40));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(40);
    }];
}

#pragma mark - get & set
- (BATGraditorButton *)confrimButton
{
    if (_confrimButton == nil) {
        _confrimButton = [[BATGraditorButton alloc]init];
        [_confrimButton setTitle:@"确认" forState:UIControlStateNormal];
        _confrimButton.enablehollowOut = YES;
        _confrimButton.titleColor = [UIColor whiteColor];
        [_confrimButton setGradientColors:@[START_COLOR,END_COLOR]];
//        [_confrimButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x0182eb, 1)] forState:UIControlStateNormal];
   //     [_confrimButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        _confrimButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _confrimButton.layer.cornerRadius = 6.0f;
        _confrimButton.layer.masksToBounds = YES;
        
        [_confrimButton addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confrimButton;
}


@end
