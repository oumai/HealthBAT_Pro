//
//  SearchHistoryCollectionViewCell.m
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchHistoryCollectionViewCell.h"
#import "Masonry.h"

@implementation BATSearchHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        WEAK_SELF(self);
        [self.contentView addSubview:self.recordLabel];
        [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _recordLabel;
}

@end
