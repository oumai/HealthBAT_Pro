//
//  HomeHeaderCollectionReusableView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHeaderView.h"

@implementation BATHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];

        WEAK_SELF(self);
        
        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.leftImageView.mas_right).offset(0);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.changeButton];
        [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];


        [self addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        
      
    }
    return self;
}

#pragma mark -
- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:STRING_DARK_COLOR backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        WEAK_SELF(self);

        [_leftButton bk_whenTapped:^{
            STRONG_SELF(self);

            if (self.leftTap) {
                self.leftTap();
            }
        }];
    }
    return _leftButton;
}


- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"更多" titleColor:STRING_MID_COLOR backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:13]];
        [_rightButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];

        // 间距
        CGFloat spacing = 15.0;

        // 图片右移
        CGSize imageSize = _rightButton.imageView.frame.size;
        _rightButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);

        // 文字左移
        CGSize titleSize = _rightButton.titleLabel.frame.size;
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);


        WEAK_SELF(self);
        [_rightButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.rightTap) {
                self.rightTap();
            }
        }];
    }
    return _rightButton;
}

- (UIButton *)changeButton {
    
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"换一换" titleColor:STRING_MID_COLOR backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:13]];
        [_changeButton setImage:[UIImage imageNamed:@"home_change"] forState:UIControlStateNormal];
        
        
        // 图片左移动
        _changeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0,-10.0, 0.0, 0.0);
        
        
        WEAK_SELF(self);
        [_changeButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.rightTap) {
                self.rightTap();
            }
        }];
    }
    return _changeButton;

    
}

@end
