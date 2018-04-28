//
//  BATHomeAssessmentCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeAssessmentCollectionViewCell.h"

@implementation BATHomeAssessmentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        WEAK_SELF(self);

        [self.contentView addSubview:self.assessmentImageView];
        [self.assessmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@-10);
        }];

        [self.assessmentImageView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.assessmentImageView.mas_left);
            make.right.equalTo(self.assessmentImageView.mas_right);
            make.bottom.equalTo(self.assessmentImageView.mas_bottom);
            make.height.mas_equalTo(21);
        }];

    }
    return self;
}

- (UIImageView *)assessmentImageView {
    if (!_assessmentImageView) {
        _assessmentImageView = [[UIImageView alloc] init];
        _assessmentImageView.layer.cornerRadius = 5.0f;
        _assessmentImageView.clipsToBounds = YES;
        [_assessmentImageView sizeToFit];
    }
    return _assessmentImageView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
        _countLabel.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
    }
    return _countLabel;
}

@end
