//
//  BATPaySuccessHeaderView.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPaySuccessHeaderView.h"
#import "Masonry.h"

@implementation BATPaySuccessHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.image = [UIImage imageNamed:@"iconfont-Payment-success"];
        [self addSubview:_statusImageView];

        _statusLabel = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _statusLabel.titleLabel.font = [UIFont systemFontOfSize:24];
        [_statusLabel setTitle:@"支付成功" forState:UIControlStateNormal];
        _statusLabel.enbleGraditor = YES;
        [_statusLabel setGradientColors:@[START_COLOR,END_COLOR]];
        _statusLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_statusLabel];

        [self setupConstraints];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.mas_top).offset(33);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.top.equalTo(_statusImageView.mas_bottom).offset(20);
    }];

}

@end
