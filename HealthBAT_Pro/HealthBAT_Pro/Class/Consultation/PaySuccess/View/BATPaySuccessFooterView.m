//
//  BATPaySuccessFooterView.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPaySuccessFooterView.h"
#import "Masonry.h"

@implementation BATPaySuccessFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _callBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];

        [_callBtn setFrame:CGRectMake(10, 20.0f, SCREEN_WIDTH - 20.0f, 40)];
        [_callBtn setTitle:@"咨询医生" forState:UIControlStateNormal];
        _callBtn.layer.cornerRadius = 3.0f;
        _callBtn.layer.masksToBounds = YES;

        [_callBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _callBtn.enablehollowOut = YES;
        _callBtn.titleColor  = [UIColor whiteColor];

        [self addSubview:_callBtn];

//        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

@end
