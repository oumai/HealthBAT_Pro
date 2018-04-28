//
//  BATHomeHealthPlanCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthPlanCollectionViewCell.h"

@implementation BATHomeHealthPlanCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.healthPlanImageView];
        [self.healthPlanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        [self.healthPlanImageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }
    return self;
}

- (UIImageView *)healthPlanImageView {
    
    if (!_healthPlanImageView) {
        _healthPlanImageView = [[UIImageView alloc] init];
        _healthPlanImageView.clipsToBounds = YES;
        [_healthPlanImageView sizeToFit];
        _healthPlanImageView.layer.cornerRadius = 3.0f;

    }
    return _healthPlanImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
