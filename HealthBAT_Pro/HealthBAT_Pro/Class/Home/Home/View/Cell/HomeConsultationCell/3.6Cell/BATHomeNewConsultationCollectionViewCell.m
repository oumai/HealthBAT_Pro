//
//  BATHomeNewConsultationCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewConsultationCollectionViewCell.h"

@implementation BATHomeNewConsultationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(13);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        
        [self.contentView addSubview:self.consultationImageView];
        [self.consultationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(0);
            make.centerX.equalTo(@0);
        }];

        [self setLeftBorderWithColor:BASE_LINECOLOR width:0.5 height:159];
    }
    return self;
}

- (UIImageView *)consultationImageView {
    if (!_consultationImageView) {
        _consultationImageView = [[UIImageView alloc] init];
        [_consultationImageView sizeToFit];
    }
    return _consultationImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 1;
    }
    return _detailLabel;
}


@end
