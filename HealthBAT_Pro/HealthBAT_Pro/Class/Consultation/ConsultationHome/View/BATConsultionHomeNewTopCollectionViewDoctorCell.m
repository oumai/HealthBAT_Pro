//
//  BATConsultionHomeNewTopCollectionViewDoctorCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeNewTopCollectionViewDoctorCell.h"

@implementation BATConsultionHomeNewTopCollectionViewDoctorCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        [self addSubview:self.doctorImageView];
        [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.height.mas_equalTo(60);
        }];
        
        [self addSubview:self.doctorNameLabel];
        [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.top.equalTo(self.doctorImageView.mas_top).offset(0);
        }];
        
        [self addSubview:self.doctorTitleLabel];
        [self.doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.centerY.equalTo(self.doctorImageView.mas_centerY).offset(0);
        }];
        
        [self addSubview:self.deptLable];
        [self.deptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.doctorImageView.mas_right).offset(10);
            make.top.equalTo(self.doctorTitleLabel.mas_bottom).offset(7);
            make.right.equalTo(self.mas_right).offset(-2);
        }];
    }
    return self;
}


- (UILabel *)deptLable{
    if (!_deptLable) {
        _deptLable = [[UILabel alloc]init];
        _deptLable.textColor = UIColorFromHEX(0x333333, 1);
        _deptLable.font = [UIFont systemFontOfSize:13];
        _deptLable.textAlignment = NSTextAlignmentLeft;
        _deptLable.text = @"全科生";
        _deptLable.numberOfLines = 0;
        [_deptLable sizeToFit];
    }
    return _deptLable;
}

- (UILabel *)doctorNameLabel{
    if (!_doctorNameLabel) {
        _doctorNameLabel = [[UILabel alloc]init];
        _doctorNameLabel.textColor = UIColorFromHEX(0x333333, 1);
        _doctorNameLabel.font = [UIFont systemFontOfSize:13];
        _doctorNameLabel.textAlignment = NSTextAlignmentLeft;
        _doctorNameLabel.text = @"何以笙";
        [_doctorNameLabel sizeToFit];
    }
    return _doctorNameLabel;
}


- (UILabel *)doctorTitleLabel{
    if (!_doctorTitleLabel) {
        _doctorTitleLabel = [[UILabel alloc]init];
        _doctorTitleLabel.textColor = UIColorFromHEX(0x333333, 1);
        _doctorTitleLabel.font = [UIFont systemFontOfSize:13];
        _doctorTitleLabel.textAlignment = NSTextAlignmentLeft;
        _doctorTitleLabel.text = @"主治医生";
        [_doctorTitleLabel sizeToFit];
    }
    return _doctorTitleLabel;
}



- (UIImageView *)doctorImageView{
    if (!_doctorImageView) {
        _doctorImageView = [[UIImageView alloc]init];
        _doctorImageView.clipsToBounds = YES;
        _doctorImageView.layer.cornerRadius = 30;
        
    }
    return _doctorImageView;
}


@end
