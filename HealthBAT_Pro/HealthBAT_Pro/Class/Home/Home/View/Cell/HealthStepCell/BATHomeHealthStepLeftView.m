//
//  BATHomeHealthStepLeftView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/5/102017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthStepLeftView.h"

@implementation BATHomeHealthStepLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        WEAK_SELF(self);
        
        [self addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        
        [self addSubview:self.stepBtn];
        [self.stepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-10);
        }];
        
        [self addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(@0);
            make.top.equalTo(self.stepBtn.mas_bottom).offset(2);
        }];
    }
    return self;
}

- (UIImageView *)backImageView {
    
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fitper"]];
        [_backImageView sizeToFit];
    }
    return _backImageView;
}

- (BATGraditorButton *)stepBtn {
    
    if (!_stepBtn) {
        _stepBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _stepBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_stepBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _stepBtn.enbleGraditor = YES;
    }
    return _stepBtn;
}

- (UILabel *)desLabel {
    
    if (!_desLabel) {
        
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:STRING_MID_COLOR textAlignment:NSTextAlignmentCenter];
        _desLabel.text = @"步数";
    }
    return _desLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
