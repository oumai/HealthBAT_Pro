//
//  HotKeyCollectionViewCell.m
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHotKeyCollectionViewCell.h"
#import "Masonry.h"

@implementation BATHotKeyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 15.f;

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
        _keyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _keyLabel;
}
@end
