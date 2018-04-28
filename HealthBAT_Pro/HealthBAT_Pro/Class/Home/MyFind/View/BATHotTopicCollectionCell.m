//
//  BATHotTopicCollectionCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHotTopicCollectionCell.h"

@implementation BATHotTopicCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 16.f;
        
        [self.contentView addSubview:self.keyLabel];
        WEAK_SELF(self);
        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _keyLabel;
}

@end
