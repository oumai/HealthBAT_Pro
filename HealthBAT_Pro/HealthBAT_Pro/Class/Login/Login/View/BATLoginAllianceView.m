//
//  BATLoginAllianceView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATLoginAllianceView.h"

@implementation BATLoginAllianceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.downBlock) {
                self.downBlock();
            }
        }];
        
        self.backgroundColor = UIColorFromHEX(0x323232,0.8);
    
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.mas_equalTo(240);
        }];
        
        [self.backView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.backView.mas_top).offset(20);
            make.centerX.equalTo(@0);
        }];
        
        [self.backView addSubview:self.littleBackView];
        [self.littleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(118, 95));
        }];
        
        [self.littleBackView addSubview:self.kmImageVIew];
        [self.kmImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-10);
        }];
        
        [self.littleBackView addSubview:self.mobileLabel];
        [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-5);
            make.centerX.equalTo(@0);
        }];
        
        [self.backView addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-20);
            make.centerX.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 40));
        }];
        
    }
    return self;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        
        [_backView bk_whenTapped:^{
    
        }];
    }
    return _backView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"使用康美健康云旗下其他应用的账号登录";
    }
    return _titleLabel;
}

- (UIView *)littleBackView {
    
    if (!_littleBackView) {
        _littleBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _littleBackView.backgroundColor = [UIColor whiteColor];
        _littleBackView.layer.cornerRadius = 3.0f;
        _littleBackView.layer.borderColor = LineColor.CGColor;
        _littleBackView.layer.borderWidth = 0.5;
    }
    return _littleBackView;
}

- (UIImageView *)kmImageVIew {
    
    if (!_kmImageVIew) {
        
        _kmImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"km"]];
    }
    return _kmImageVIew;
}
- (UILabel *)mobileLabel {
    
    if (!_mobileLabel) {
        _mobileLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:STRING_DARK_COLOR textAlignment:NSTextAlignmentCenter];
    }
    return _mobileLabel;
}

- (BATGraditorButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _loginBtn.titleColor = [UIColor whiteColor];
        
        _loginBtn.layer.cornerRadius = 4.0f;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        _loginBtn.enablehollowOut = YES;
        _loginBtn.customCornerRadius = 4.0f;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        WEAK_SELF(self);
        [_loginBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.loginBlock) {
                self.loginBlock();
            }
        }];
    }
    return _loginBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
