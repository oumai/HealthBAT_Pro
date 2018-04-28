//
//  BATNearFamilyDoctorRemindView.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNearFamilyDoctorRemindView.h"

@implementation BATNearFamilyDoctorRemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.subTitleLable];
        [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLable.mas_bottom).offset(3);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}


- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.text = @"千万不要走开";
        [_titleLable sizeToFit];
    }
    
    return _titleLable;
}

- (UILabel *)subTitleLable{
    if (!_subTitleLable) {
        _subTitleLable = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _subTitleLable.backgroundColor = [UIColor clearColor];
        _subTitleLable.text = @"正在为您查找医生...";
        [_subTitleLable sizeToFit];
    }
    
    return _subTitleLable;
}


@end
