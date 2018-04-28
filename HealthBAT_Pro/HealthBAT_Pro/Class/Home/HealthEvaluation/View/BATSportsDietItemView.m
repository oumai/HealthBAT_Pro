//
//  BATSportsDietItemView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSportsDietItemView.h"

@implementation BATSportsDietItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.percentLabel];
    
    WEAK_SELF(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.equalTo(self);
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(27.5 * scaleValue, 27.5 * scaleValue));
        } else {
            make.size.mas_offset(CGSizeMake(27.5, 27.5));
        }
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.top.equalTo(self);
    }];
    
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

#pragma mark - get & set
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        if (iPhone5 || iPhone4) {
            _titleLabel.font = [UIFont systemFontOfSize:14 * scaleValue];
        } else {
            _titleLabel.font = [UIFont systemFontOfSize:14];
        }
        _titleLabel.textColor = UIColorFromHEX(0xffffff, 1);
    }
    return _titleLabel;
}

- (UILabel *)percentLabel
{
    if (_percentLabel == nil) {
        _percentLabel = [[UILabel alloc] init];
        if (iPhone5 || iPhone4) {
            _percentLabel.font = [UIFont systemFontOfSize:12 * scaleValue];
        } else {
            _percentLabel.font = [UIFont systemFontOfSize:12];
        }
        _percentLabel.textColor = UIColorFromHEX(0xffffff, 1);
    }
    return _percentLabel;
}

@end
