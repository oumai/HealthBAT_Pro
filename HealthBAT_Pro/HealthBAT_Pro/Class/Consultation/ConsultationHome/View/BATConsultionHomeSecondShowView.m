//
//  BATConsultionHomeSecondShowView.m
//  HealthBAT_Pro
//
//  Created by four on 17/2/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeSecondShowView.h"

@implementation BATConsultionHomeSecondShowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.imageV.mas_right).offset(10);
            make.centerY.equalTo(self.imageV.mas_centerY);
//            make.width.mas_equalTo(150);
            make.height.mas_equalTo(15);
            [self.nameLable sizeToFit];
        }];
        
    }
    return self;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"icon-zxys-1"];
        _imageV.layer.cornerRadius = 30;
    }
    return _imageV;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = UIColorFromRGB(53,154,43,1);
        _nameLable.font = [UIFont systemFontOfSize:18];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLable;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
