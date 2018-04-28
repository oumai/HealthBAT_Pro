//
//  BATOnlineStudyCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/12/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeOnlineStudyCollectionViewCell.h"

@implementation BATHomeOnlineStudyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.backImage];
        [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        [self.backImage addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }
    return self;
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.clipsToBounds = YES;
        [_backImage sizeToFit];
        _backImage.layer.cornerRadius = 3.0f;
    }
    return _backImage;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}


@end
