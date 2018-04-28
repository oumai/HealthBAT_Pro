//
//  BATConsultionHomeNewTopView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeNewTopView.h"

@implementation BATConsultionHomeNewTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swichTopView:)];
        swipe.direction=UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipe];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swichTopView:)];
        [self addGestureRecognizer:tap];
        
        CGFloat range;
        if (iPhone5) {
            range = 20;
        }else{
            range = 40;
        }
        
        self.backgroundColor = [UIColor clearColor];
        WEAK_SELF(self);
        [self addSubview:self.bgview];
        [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.mas_top).offset(0);
            make.width.mas_equalTo(SCREEN_WIDTH - 40);
            make.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.doctorImageView];
        [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.bgview.mas_left).offset(20);
            make.centerY.equalTo(self.bgview.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(25);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.centerY.equalTo(self.bgview.mas_centerY);
        }];
        

        [self addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(range);
            make.centerY.equalTo(self.bgview.mas_centerY);
        }];

        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.bgview.mas_bottom).offset(-0.5);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(0.5);
        }];
        
        [self addSubview:self.pushImageView];
        [self.pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.bgview.mas_bottom).offset(-0.5);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)swichTopView:(id)sender{
    if (self.PushTopViewBlock) {
        self.PushTopViewBlock();
    }
}

- (UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc]initWithFrame:CGRectZero];
        _bgview.backgroundColor=[UIColor whiteColor];
//        WEAK_SELF(self);
//        [_pushImageView bk_whenTapped:^{
//            STRONG_SELF(self);
//            if (self.PushTopViewBlock) {
//                self.PushTopViewBlock();
//            }
//        }];
//        
//        [_bgview bk_whenTapped:^{
//            if (self.PushSearchDoctorBlock) {
//                self.PushSearchDoctorBlock();
//            }
//        }];
    }
    return _bgview;
}


- (UIImageView *)doctorImageView{
    if (!_doctorImageView) {
        _doctorImageView = [[UIImageView alloc]init];
        _doctorImageView.image = [UIImage imageNamed:@"ic-consultion-zixun-zhaodaifu"];
    }
    return _doctorImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _titleLabel.text = @"找医生咨询";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = UIColorFromHEX(0x999999, 1);
        _descLabel.text = @"搜全国名医 对症咨询";
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [_descLabel sizeToFit];
    }
    return _descLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor=END_COLOR;
    }
    return _lineView;
}

- (UIImageView *)pushImageView{
    if (!_pushImageView) {
        _pushImageView = [[UIImageView alloc]init];
        _pushImageView.image = [UIImage imageNamed:@"icon-consultion-xl"];
//        _pushImageView.userInteractionEnabled = YES;
//        WEAK_SELF(self);
//        [_pushImageView bk_whenTapped:^{
//            STRONG_SELF(self);
//            if (self.PushTopViewBlock) {
//                self.PushTopViewBlock();
//            }
//        }];
    }
    return _pushImageView;
}


@end
