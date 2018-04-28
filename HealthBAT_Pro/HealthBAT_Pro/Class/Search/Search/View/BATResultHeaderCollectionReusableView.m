//
//  ResultHeaderCollectionReusableView.m
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATResultHeaderCollectionReusableView.h"
#import "Masonry.h"

@implementation BATResultHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColorFromRGB(238, 238, 238, 1);
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);

//        [self addSubview:self.blueView];
//        [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.equalTo(self.mas_left).offset(10);
//            make.centerY.equalTo(self.mas_centerY);
//            make.height.mas_equalTo(20);
//            make.width.mas_equalTo(2);
//        }];

        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(17);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (void)moreButtonTapped {
    if (self.moreBlock) {
        self.moreBlock(self.titleLabel.text,self.type);
    }
}
- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
    }
    return _blueView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _subTitleLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"更多" titleColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        [_moreButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];

        // 还可增设间距
        CGFloat spacing = 15.0;

        // 图片右移
        CGSize imageSize = _moreButton.imageView.frame.size;
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);

        // 文字左移
        CGSize titleSize = _moreButton.titleLabel.frame.size;
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);


        [_moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
