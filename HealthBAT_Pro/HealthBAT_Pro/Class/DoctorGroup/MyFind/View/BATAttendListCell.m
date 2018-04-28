//
//  BATAttendListCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/9/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAttendListCell.h"

@implementation BATAttendListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 16.f;
        
        [self.contentView addSubview:self.keyLabel];
        WEAK_SELF(self);
        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (BATGraditorButton *)keyLabel {
    if (!_keyLabel) {
        //  _keyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _keyLabel = [[BATGraditorButton alloc]init];
        _keyLabel.enbleGraditor = YES;
        _keyLabel.titleLabel.font = [UIFont systemFontOfSize:13];
        [_keyLabel setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
        _keyLabel.userInteractionEnabled = NO;
    }
    return _keyLabel;
}


@end
