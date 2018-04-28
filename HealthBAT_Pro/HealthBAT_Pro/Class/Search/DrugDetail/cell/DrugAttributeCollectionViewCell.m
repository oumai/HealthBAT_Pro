//
//  DrugAttributeCollectionViewCell.m
//  HealthBAT
//
//  Created by four on 16/8/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "DrugAttributeCollectionViewCell.h"

@implementation DrugAttributeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(32);
        }];
    
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor =  UIColorFromHEX(0X333333, 1);
       
    }
    return _titleLabel;
}

@end
