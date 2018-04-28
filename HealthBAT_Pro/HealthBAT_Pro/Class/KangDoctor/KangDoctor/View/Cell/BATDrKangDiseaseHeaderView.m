//
//  BATDrKangDiseaseHeaderView.m
//  HealthBAT_Pro
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangDiseaseHeaderView.h"

@implementation BATDrKangDiseaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleBtn];
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.titleBtn.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        }];
    }
    return self;
}

- (BATGraditorButton *)titleBtn {
    
    if (!_titleBtn) {
        
        _titleBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.userInteractionEnabled = NO;
        
        _titleBtn.isDeleteBorder = YES;

        _titleBtn.layer.cornerRadius = 15.0f;
        _titleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleBtn.layer.masksToBounds = YES;
        [_titleBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        _titleBtn.enablehollowOut = NO;
        _titleBtn.customCornerRadius = 15.0f;
        _titleBtn.customColor = [UIColor whiteColor];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_titleBtn sizeToFit];
        
    }
    return _titleBtn;
}

- (BATGraditorButton *)line {
    
    if (!_line) {
        
        _line = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _line.userInteractionEnabled = NO;
        
        _line.layer.masksToBounds = YES;
        [_line setGradientColors:@[START_COLOR,END_COLOR]];
        
        _line.enablehollowOut = NO;
        _line.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _line;
}
@end
