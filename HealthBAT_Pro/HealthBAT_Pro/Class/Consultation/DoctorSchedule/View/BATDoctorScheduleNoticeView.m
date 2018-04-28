//
//  BATDoctorScheduleNoticeView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleNoticeView.h"

@implementation BATDoctorScheduleNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        _leftLabel = [[UILabel alloc] init];
//        _leftLabel.layer.borderColor = UIColorFromHEX(0x45a0f0, 1).CGColor;
//        _leftLabel.layer.borderWidth = 0.5f;
//        [self addSubview:_leftLabel];
        
        _leftImageView = [[UIImageView alloc]init];
        [self addSubview:_leftImageView];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.backgroundColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = UIColorFromHEX(0x666666, 1);
        [self addSubview:_rightLabel];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(_leftImageView.mas_right).offset(5);
        make.top.equalTo(_leftImageView.mas_top);
        make.bottom.equalTo(_leftImageView.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
}

@end
