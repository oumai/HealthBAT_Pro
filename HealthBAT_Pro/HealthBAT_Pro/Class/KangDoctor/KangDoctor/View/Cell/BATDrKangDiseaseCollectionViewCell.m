//
//  BATDrKangDiseaseCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/192017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangDiseaseCollectionViewCell.h"

@implementation BATDrKangDiseaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.keyWordLabel];
        WEAK_SELF(self);
        [self.keyWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (BATGraditorButton *)keyWordLabel {
    if (!_keyWordLabel) {
        _keyWordLabel = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _keyWordLabel.userInteractionEnabled = NO;
        
        _keyWordLabel.layer.cornerRadius = 15.0f;
        _keyWordLabel.layer.masksToBounds = YES;
        [_keyWordLabel setGradientColors:@[START_COLOR,END_COLOR]];
        
        _keyWordLabel.enablehollowOut = NO;
        _keyWordLabel.customCornerRadius = 15.0f;
        _keyWordLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _keyWordLabel;
}

@end
