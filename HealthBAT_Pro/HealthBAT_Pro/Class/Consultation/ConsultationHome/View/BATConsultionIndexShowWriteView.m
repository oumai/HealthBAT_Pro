//
//  BATConsultionIndexShowWriteView.m
//  HealthBAT_Pro
//
//  Created by four on 16/11/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionIndexShowWriteView.h"

@implementation BATConsultionIndexShowWriteView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(37.5);
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.imageV.mas_right).offset(10);
            make.centerY.equalTo(self.imageV);
            make.height.mas_equalTo(15);
            [self.nameLable sizeToFit];
        }];
        
    }
    return self;
}


- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"icon-wzxx"];
    }
    return _imageV;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = UIColorFromHEX(0x333333, 1);
        _nameLable.text = @"马上问医生";
        _nameLable.font = [UIFont systemFontOfSize:18];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
}
@end
