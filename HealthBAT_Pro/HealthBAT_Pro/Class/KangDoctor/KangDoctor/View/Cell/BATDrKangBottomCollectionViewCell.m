//
//  BATDrKangBottomCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/212017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangBottomCollectionViewCell.h"

@implementation BATDrKangBottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [self.contentView addSubview:self.keyWordLabel];
        [self.keyWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(@0);
        }];
        
//        [self.contentView addSubview:self.keyLabel];
//        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(@0);
//        }];
    }
    return self;
}

//- (BATGraditorButton *)keyLabel {
//    if (!_keyLabel) {
//        _keyLabel = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
//        _keyLabel.userInteractionEnabled = NO;
//
//        _keyLabel.layer.cornerRadius = 15.0f;
//        _keyLabel.layer.masksToBounds = YES;
//        [_keyLabel setGradientColors:@[UIColorFromHEX(0x1c9185, 1),UIColorFromHEX(0x3f8b46, 1)]];
//
//        _keyLabel.enablehollowOut = YES;
//        _keyLabel.customColor = BASE_BACKGROUND_COLOR;
//        _keyLabel.customCornerRadius = 15.0f;
//        _keyLabel.titleLabel.font = [UIFont systemFontOfSize:15];
//        _keyLabel.titleColor  = [UIColor whiteColor];
//
//        _keyLabel.hidden = YES;
//    }
//    return _keyLabel;
//}

//- (BATGraditorButton *)keyWordLabel {
//    if (!_keyWordLabel) {
//        _keyWordLabel = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
//        _keyWordLabel.userInteractionEnabled = NO;
//
//        _keyWordLabel.layer.cornerRadius = 15.0f;
//        _keyWordLabel.layer.masksToBounds = YES;
//        [_keyWordLabel setGradientColors:@[START_COLOR,END_COLOR]];
//
//        _keyWordLabel.enablehollowOut = YES;
//        _keyWordLabel.customColor = BASE_BACKGROUND_COLOR;
//        _keyWordLabel.customCornerRadius = 15.0f;
//        _keyWordLabel.titleLabel.font = [UIFont systemFontOfSize:15];
//        _keyWordLabel.titleColor  = [UIColor whiteColor];
//    }
//    return _keyWordLabel;
//}

- (UILabel *)keyWordLabel {
    
    if (!_keyWordLabel) {
        
        _keyWordLabel = [[UILabel alloc] init];
        _keyWordLabel.layer.cornerRadius = 5.0f;
        _keyWordLabel.layer.masksToBounds = YES;
        [_keyWordLabel setBackgroundColor:END_COLOR];

        _keyWordLabel.font = [UIFont systemFontOfSize:15];
        _keyWordLabel.textColor  = [UIColor whiteColor];
        _keyWordLabel.textAlignment = NSTextAlignmentCenter;
        
        [_keyWordLabel sizeToFit];
    }
    return _keyWordLabel;
}

@end
