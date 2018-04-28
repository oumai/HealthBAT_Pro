//
//  ConfirmPayFooterView.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConfirmPayFooterView.h"
#import "Masonry.h"

@implementation BATConfirmPayFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        _confirmPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_confirmPayBtn setFrame:CGRectMake(10, 30.0f, SCREEN_WIDTH - 20.0f, 40)];
//        [_confirmPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
//        [_confirmPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_confirmPayBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
//        _confirmPayBtn.layer.cornerRadius = 6.0f;
//        _confirmPayBtn.layer.masksToBounds = YES;
        
        
        _confirmPayBtn = [[BATGraditorButton alloc] initWithFrame:CGRectMake(10, 45.0f, SCREEN_WIDTH - 20.0f, 40)];
        [_confirmPayBtn setTitle:@"确认支付" forState:UIControlStateNormal] ;
        _confirmPayBtn.enablehollowOut = YES;
        _confirmPayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _confirmPayBtn.titleColor = [UIColor whiteColor];
        [_confirmPayBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _confirmPayBtn.layer.cornerRadius = 6.0f;
        _confirmPayBtn.layer.masksToBounds = YES;
        [self addSubview:_confirmPayBtn];

//        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.width.equalTo(self.mas_width).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

@end
