//
//  BATDoctorInfoCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorInfoCollectionViewCell.h"

@implementation BATConsultationDoctorInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self.contentView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(11);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];

        [self.contentView addSubview:self.hospitalLevelImageView];
        [self.hospitalLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.headerImageView.mas_left);
            make.top.equalTo(self.headerImageView.mas_top);
        }];

        [self.contentView addSubview:self.onlineStationImageView];
        [self.onlineStationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.headerImageView.mas_right);
            make.bottom.equalTo(self.headerImageView.mas_bottom);
        }];

        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.centerX.equalTo(self.mas_centerX);
        }];

        [self.contentView addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.centerX.equalTo(self.mas_centerX);
        }];

        [self.contentView addSubview:self.departmentLabel];
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
//        _headerImageView.layer.shouldRasterize = YES;
//        _headerImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _headerImageView.opaque = YES;
        _headerImageView.backgroundColor = [UIColor whiteColor];
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
        _departmentLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departmentLabel;
}
@end
