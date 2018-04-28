//
//  BATNearFamilyDoctorListView.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNearFamilyDoctorListView.h"

@implementation BATNearFamilyDoctorListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.bigBGView];
        [self.bigBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        [self.bigBGView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(20);
            make.bottom.equalTo(self.mas_bottom).offset(-60);
            make.width.mas_equalTo(SCREEN_WIDTH - 40);
            make.height.mas_equalTo(75);
        }];
        
        [self.bgView addSubview:self.nearIconView];
        [self.nearIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.bgView.mas_left).offset(15);
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.height.mas_equalTo(30);
            make.width.mas_offset(25);
        }];
        
        [self.bgView addSubview:self.nearLable];
        [self.nearLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.left.equalTo(self.nearIconView.mas_right).offset(10);
        }];
        
        [self.bgView addSubview:self.numberLable];
        [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bgView.mas_centerY).offset(-3);
            make.left.equalTo(self.nearLable.mas_right).offset(11);
        }];
        
        [self.bgView addSubview:self.doctorLable];
        [self.doctorLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.left.equalTo(self.numberLable.mas_right).offset(11);
        }];
        
    }
    return self;
}


- (UIView *)bigBGView{
    if (!_bigBGView) {
        _bigBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _bigBGView.backgroundColor = UIColorFromHEX(0x000000, 0.3);
        _bigBGView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_bigBGView bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.reloadSearchBlock) {
                self.reloadSearchBlock();
            }
        }];
    }
    return  _bigBGView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.f;
        _bgView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_bgView bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.pushNearFamilyDoctorListBlock) {
                self.pushNearFamilyDoctorListBlock();
            }
        }];
    }
    return  _bgView;
}

- (UIImageView *)nearIconView{
    if (!_nearIconView) {
        _nearIconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _nearIconView.image = [UIImage imageNamed:@"附近"];
    }
    return _nearIconView;
}

- (UILabel *)nearLable{
    if (!_nearLable) {
        _nearLable = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _nearLable.text = @"附近";
        [_nearLable sizeToFit];
    }
    
    return _nearLable;
}

- (UILabel *)numberLable{
    if (!_numberLable) {
        _numberLable = [UILabel labelWithFont:[UIFont systemFontOfSize:20] textColor:UIColorFromHEX(0x0182eb, 1) textAlignment:NSTextAlignmentCenter];
        _numberLable.text = @"0";
        [_numberLable sizeToFit];
    }
    
    return _numberLable;
}

- (UILabel *)doctorLable{
    if (!_doctorLable) {
        _doctorLable = [UILabel labelWithFont:[UIFont systemFontOfSize:18] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
        _doctorLable.text = @"个相关医生";
        [_doctorLable sizeToFit];
    }
    
    return _doctorLable;
}

@end
