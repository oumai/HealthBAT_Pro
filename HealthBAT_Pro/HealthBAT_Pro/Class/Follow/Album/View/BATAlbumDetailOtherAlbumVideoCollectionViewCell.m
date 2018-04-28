//
//  BATAlbumDetailOtherAlbumVideoCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailOtherAlbumVideoCollectionViewCell.h"

@implementation BATAlbumDetailOtherAlbumVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.videoImageView];
        [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.centerY.equalTo(self);
            make.width.mas_equalTo(self.frame.size.width - 10);
        }];
    
    }
    return self;
}


- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.clipsToBounds = YES;
        _videoImageView.layer.cornerRadius = 5;
    }
    return _videoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
