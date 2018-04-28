//
//  BATConsultationHeaderCollectionReusableView.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationHeaderCollectionReusableView.h"

@implementation BATConsultationHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBottomBorderWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] width:SCREEN_WIDTH height:0.5];

        WEAK_SELF(self);
        [self addSubview:self.departNameLabel];
        [self.departNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addGestureRecognizer:self.tap];
    }
    return self;
}

- (void)headerClick {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

#pragma mark - getter

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
    }
    return _tap;
}
- (UILabel *)departNameLabel {
    if (!_departNameLabel) {
        _departNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _departNameLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"更多" titleColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        [_moreButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        _moreButton.userInteractionEnabled = NO;
        // 间距
        CGFloat spacing = 15.0;

        // 图片右移
        CGSize imageSize = _moreButton.imageView.frame.size;
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);

        // 文字左移
        CGSize titleSize = _moreButton.titleLabel.frame.size;
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    }
    return _moreButton;
}
@end
