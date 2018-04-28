//
//  BATHomeDoctorCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeDoctorCollectionViewCell.h"

@implementation BATHomeDoctorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-15);
            make.centerX.equalTo(@0);
        }];
        
        [self.contentView addSubview:self.doctorImageView];
        [self.doctorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-15);
            make.centerX.equalTo(@0);
        }];
    
    }
    return self;
}

- (UIImageView *)doctorImageView {
    if (!_doctorImageView) {
        _doctorImageView = [[UIImageView alloc] init];
        [_doctorImageView sizeToFit];
    }
    return _doctorImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}


@end
