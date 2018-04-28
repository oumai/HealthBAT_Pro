//
//  BATNetworkStateView.m
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "BATNetworkStateView.h"

@implementation BATNetworkStateView

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
    [self addSubview:self.networkStateImageView];
    [self addSubview:self.networkStateLabel];
    
    WEAK_SELF(self);
    [self.networkStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.bottom.equalTo(self);
    }];
    
    [self.networkStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(22, 18));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.networkStateLabel.mas_left).offset(-10);
        make.left.greaterThanOrEqualTo(self.mas_left).offset(10);
    }];

}

#pragma mark - get & set
- (UIImageView *)networkStateImageView
{
    if (_networkStateImageView == nil) {
        _networkStateImageView = [[UIImageView alloc] init];
    }
    return _networkStateImageView;
}

- (UILabel *)networkStateLabel
{
    if (_networkStateLabel == nil) {
        _networkStateLabel = [[UILabel alloc] init];
        _networkStateLabel.font = [UIFont systemFontOfSize:18];
        _networkStateLabel.textColor = UIColorFromHEX(0xfffefe, 1);
        _networkStateLabel.backgroundColor = [UIColor clearColor];
        _networkStateLabel.textAlignment = NSTextAlignmentCenter;
        [_networkStateLabel sizeToFit];
    }
    return _networkStateLabel;
}

@end
