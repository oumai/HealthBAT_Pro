//
//  RegisterFooterView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegisterFooterView.h"

@implementation BATRegisterFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

//        [self setTopBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0.5];
        [self addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(SCREEN_WIDTH-44*2);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

- (BATGraditorButton *)confirmButton {
    if (!_confirmButton) {
//        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确认预约" titleColor:[UIColor whiteColor] backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        _confirmButton = [[BATGraditorButton alloc]init];
        [_confirmButton setTitle:@"确认预约" forState:UIControlStateNormal];
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = 6.0f;
        _confirmButton.enablehollowOut = YES;
        _confirmButton.titleColor = [UIColor whiteColor];
        [_confirmButton setGradientColors:@[START_COLOR,END_COLOR]];
        WEAK_SELF(self);
        [_confirmButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.confirmRegister) {
                self.confirmRegister();
            }
        }];
    }
    return _confirmButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
