//
//  BATConsultionHomeNewTopCollectionViewHeaderViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeNewTopCollectionViewHeaderViewCell.h"

@implementation BATConsultionHomeNewTopCollectionViewHeaderViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.height.mas_equalTo(SCREEN_WIDTH - 20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}


- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = UIColorFromHEX(0x333333, 1);
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        [_titleLable sizeToFit];
    }
    return _titleLable;
}


@end
