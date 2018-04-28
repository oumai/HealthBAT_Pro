//
//  BATDoctorInfoCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorInfoCollectionViewCell.h"

@implementation BATDoctorInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(11);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
        }];

        [self addSubview:self.hospitalLevelImageView];
        [self.hospitalLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_left);
            make.top.equalTo(self.headerImageView.mas_top);
        }];

        [self addSubview:self.onlineStationImageView];
        [self.onlineStationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerImageView.mas_right);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
        }];

        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.centerX.equalTo(self.mas_centerX);
        }];

        [self addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.centerX.equalTo(self.mas_centerX);
        }];

        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.levelLabel.mas_bottom).offset(5);
            make.centerX.equalTo(self.mas_centerX);
        }];

    }
    return self;
}

#pragma mark - 
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 35.f;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

- (UIImageView *)hospitalLevelImageView {
    if (!_hospitalLevelImageView) {
        _hospitalLevelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三甲"]];
    }
    return _hospitalLevelImageView;
}

- (UIImageView *)onlineStationImageView {
    if (!_onlineStationImageView) {
        _onlineStationImageView = [[UIImageView alloc] init];
    }
    return _onlineStationImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _levelLabel;
}

- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:9] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departmentLabel;
}
@end
