//
//  BATDoctorScheduleFooterView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleFooterView.h"
#import "BATDoctorScheduleNoticeView.h"

@implementation BATDoctorScheduleFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        BATDoctorScheduleNoticeView *preNoticeView = nil;
        for (int i = 0; i < 2; i++) {
            BATDoctorScheduleNoticeView *noticeView = [[BATDoctorScheduleNoticeView alloc] init];
            if (i == 0) {
                noticeView.leftImageView.image = [UIImage imageNamed:@"schudule-nuchoose"];
                noticeView.rightLabel.text = @"可预约";
            } else if (i == 1) {
//                noticeView.leftLabel.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
                noticeView.rightLabel.text = @"已预约";
                noticeView.leftImageView.image = [UIImage imageNamed:@"schedule-choose"];
            }
            
            [self addSubview:noticeView];
            
            WEAK_SELF(self);
            [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.top.equalTo(self.mas_top).offset(15);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(30);
                
                if (i != 0) {
                    make.left.equalTo(preNoticeView.mas_right).offset(10);
                    make.right.equalTo(self.mas_right).offset(10);
                }
                
            }];
            preNoticeView = noticeView;

            
        }
        
//        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
//        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_confirmButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
//        _confirmButton.layer.cornerRadius = 6.0f;
//        _confirmButton.layer.masksToBounds = YES;
//        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        
        _confirmButton = [[BATGraditorButton alloc] init];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal] ;
        _confirmButton.enablehollowOut = YES;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirmButton.titleColor = [UIColor whiteColor];
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = 6.f;
        [_confirmButton setGradientColors:@[START_COLOR,END_COLOR]];

        
        [self addSubview:_confirmButton];
        
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.mas_top).offset(70);
        make.height.mas_equalTo(40);
    }];
}

@end
