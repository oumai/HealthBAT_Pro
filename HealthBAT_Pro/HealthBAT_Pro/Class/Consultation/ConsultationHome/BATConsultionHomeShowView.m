//
//  BATConsultionHomeShowView.m
//  HealthBAT_Pro
//
//  Created by four on 16/11/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeShowView.h"

@implementation BATConsultionHomeShowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
        }];
        
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.imageV.mas_right).offset(10);
            make.bottom.equalTo(self.imageV.mas_centerY).offset(-5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(15);
        }];
        
        
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.imageV.mas_right).offset(10);
            make.top.equalTo(self.imageV.mas_centerY).offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}


- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"icon-nvys"];
        _imageV.layer.cornerRadius = 30;
    }
    return _imageV;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = UIColorFromHEX(0x333333, 1);
        _nameLable.text = @"值班医生";
        _nameLable.font = [UIFont systemFontOfSize:18];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = UIColorFromHEX(0x666666, 1);
        _subTitleLabel.text = @"我们随时为你服务";
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitleLabel;
}
@end
