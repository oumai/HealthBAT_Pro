//
//  BATTraditionNextFooter.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionNextFooter.h"

@implementation BATTraditionNextFooter

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.nextBtn];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    return self;
}

#pragma mark -
- (UIButton *)nextBtn {

    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 40.f;
        _nextBtn.layer.borderWidth = 2.0f;
        _nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _nextBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
