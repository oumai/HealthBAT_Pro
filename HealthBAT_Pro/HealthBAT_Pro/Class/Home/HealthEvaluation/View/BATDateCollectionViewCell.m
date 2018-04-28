//
//  BATDateCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDateCollectionViewCell.h"

@implementation BATDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    
    WEAK_SELF(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        if (iPhone5 || iPhone4) {
            make.top.equalTo(self.contentView.mas_top).offset(15 * scaleValue);
        } else {
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.contentView.mas_centerX);
        
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(42 * scaleValue, 42 * scaleValue));
        } else {
            make.size.mas_offset(CGSizeMake(42, 42));
        }
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        if (iPhone5 || iPhone4) {
            _titleLabel.font = [UIFont systemFontOfSize:12 * scaleValue];
        } else {
            _titleLabel.font = [UIFont systemFontOfSize:12];
        }
        _titleLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
