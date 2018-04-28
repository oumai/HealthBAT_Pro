//
//  BATDoctorHorderCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorHorderCollectionViewCell.h"

@implementation BATDoctorHorderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@10);
        }];
        
        [self.contentView addSubview:self.doctorHorderImageView];
        [self.doctorHorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/4.0);
        }];
        
        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(@10);
            make.right.equalTo(self.doctorHorderImageView.mas_left).offset(-4);
        }];
        
        [self bringSubviewToFront:self.nameLabel];
        
        [self.contentView setRightBorderWithColor:BASE_LINECOLOR width:0.5 height:75];
    }
    return self;
}

- (UIImageView *)doctorHorderImageView {
    if (!_doctorHorderImageView) {
        _doctorHorderImageView = [[UIImageView alloc] init];
        _doctorHorderImageView.layer.cornerRadius = 5.0f;
        _doctorHorderImageView.clipsToBounds = YES;
        [_doctorHorderImageView sizeToFit];
    }
    return _doctorHorderImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}
@end
