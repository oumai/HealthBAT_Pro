//
//  BATDoctorServiceBottomView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorServiceBottomView.h"

@implementation BATDoctorServiceBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);
        [self addSubview:self.severStartBtn];
        [self.severStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (BATGraditorButton *)severStartBtn{
    if (!_severStartBtn) {
        _severStartBtn = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_severStartBtn setTitle:@"暂未开通" forState:UIControlStateNormal] ;
        
        if (iPhoneX) {
            [_severStartBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 17, 0)];
        }
        
        _severStartBtn.enablehollowOut = YES;
        _severStartBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _severStartBtn.titleColor = [UIColor whiteColor];
        [_severStartBtn setGradientColors:@[START_COLOR,END_COLOR]];
        [_severStartBtn bk_whenTapped:^{
            if (self.startSeverTap) {
                self.startSeverTap();
            }
        }];
    }
    
    return _severStartBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
