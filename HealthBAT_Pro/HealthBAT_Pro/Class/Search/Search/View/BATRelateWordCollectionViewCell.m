//
//  RelateWordCollectionViewCell.m
//  HealthBAT
//
//  Created by KM on 16/8/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRelateWordCollectionViewCell.h"

@implementation BATRelateWordCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self.contentView addSubview:self.relateWordLabel];
        [self.relateWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(5);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (UILabel *)relateWordLabel {
    if (!_relateWordLabel) {
        _relateWordLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    }
    return _relateWordLabel;
}
@end
