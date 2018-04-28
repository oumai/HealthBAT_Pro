//
//  BATTrainInfoFooterView.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainInfoFooterView.h"

@implementation BATTrainInfoFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 45));
            make.centerX.equalTo(@0);
        }];
        
    }
    return self;
}


- (void)submitButtonAction:(UIButton *)button {
    
    if (self.submitBlock) {
        self.submitBlock();
    }
}


#pragma mark - setter
- (BATGraditorButton *)submitButton
{
    if (_submitButton == nil) {
//        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton = [[BATGraditorButton alloc]init];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleColor = [UIColor whiteColor];
        _submitButton.enablehollowOut = YES;
        [_submitButton setGradientColors:@[START_COLOR,END_COLOR]];
     //   [_submitButton setBackgroundImage:[Tools imageFromColor:BASE_COLOR] forState:UIControlStateNormal];
       // [_submitButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitButton.layer.cornerRadius = 6.0f;
        _submitButton.layer.masksToBounds = YES;
    }
    return _submitButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
