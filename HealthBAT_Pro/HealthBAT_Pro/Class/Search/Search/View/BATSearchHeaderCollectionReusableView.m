//
//  SearchHeaderCollectionReusableView.m
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchHeaderCollectionReusableView.h"
#import "Masonry.h"

@implementation BATSearchHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(frame.size.height-10);
            make.width.mas_equalTo(frame.size.height-10);
        }];

        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addSubview:self.clearButton];
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(117);
        }];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];

    }
    return self;
}

- (void)clearButtonTapped {
    if (self.clearBlock) {
        self.clearBlock();
    }
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"清空搜索记录" titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:13]];
        _clearButton.layer.cornerRadius = 12.f;
        _clearButton.layer.borderColor = BASE_LINECOLOR.CGColor;
        _clearButton.layer.borderWidth = 0.5;
        [_clearButton addTarget:self action:@selector(clearButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
@end
