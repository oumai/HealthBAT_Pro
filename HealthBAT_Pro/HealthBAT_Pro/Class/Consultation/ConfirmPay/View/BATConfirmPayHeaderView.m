//
//  BATConfirmPayHeaderView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/22017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConfirmPayHeaderView.h"

@implementation BATConfirmPayHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(@0);
        }];
        
        [self addSubview:self.selcetedBtn];
        [self.selcetedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}


- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentLeft];
        
        _titleLabel.text = @"是否使用优惠码";
    }
    return _titleLabel;
}

- (UIButton *)selcetedBtn {
    
    if (!_selcetedBtn) {
        
        _selcetedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selcetedBtn setBackgroundImage:[UIImage imageNamed:@"select-p"] forState:UIControlStateNormal];
        [_selcetedBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        
        WEAK_SELF(self);
        [_selcetedBtn bk_whenTapped:^{
            STRONG_SELF(self);
            self.selcetedBtn.selected = !self.selcetedBtn.selected;
            
            if (self.selectCouponCodeBlock) {
                self.selectCouponCodeBlock(self.selcetedBtn.selected);
            }
        }];
    }
    return _selcetedBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
