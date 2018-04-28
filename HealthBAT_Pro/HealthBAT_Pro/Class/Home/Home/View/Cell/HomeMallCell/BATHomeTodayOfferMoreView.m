//
//  BATHomeTodayOfferMoreView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/92017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTodayOfferMoreView.h"

@implementation BATHomeTodayOfferMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self addSubview:self.moreImageView];
        [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-10);
        }];
        
        [self addSubview:self.moreLabel];
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.moreImageView.mas_bottom).offset(5);
            make.centerX.equalTo(@0);
        }];
    }
    return self;
}

- (UIImageView *)moreImageView {
    
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gd"]];
    }
    return _moreImageView;
}

- (UILabel *)moreLabel {
    
    if (!_moreLabel) {
        _moreLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        _moreLabel.text = @"更多秒杀";
    }
    return _moreLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
