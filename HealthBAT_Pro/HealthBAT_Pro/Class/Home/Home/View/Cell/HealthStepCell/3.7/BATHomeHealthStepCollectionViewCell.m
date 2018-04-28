//
//  BATHomeHealthStepCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthStepCollectionViewCell.h"

@implementation BATHomeHealthStepCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@18.5);
            make.centerX.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
            make.centerX.equalTo(@15);
        }];
        
        [self.contentView addSubview:self.detailImageView];
        [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.detailLabel.mas_centerY);
            make.right.mas_equalTo(self.detailLabel.mas_left).offset(-10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = [[UIImageView alloc] init];
    }
    return _detailImageView;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentCenter];
    }
    return _detailLabel;
}


@end
