//
//  TopSearchView.m
//  HealthBAT
//
//  Created by KM on 16/7/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATTopSearchView.h"
#import "Masonry.h"

@implementation BATTopSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        WEAK_SELF(self);
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.bottom.equalTo(@-7);
            make.right.equalTo(@0);
            make.height.mas_equalTo(30);
        }];

//        [self.backView addSubview:self.chooseButton];
//        [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            make.bottom.equalTo(@0);
//            make.height.mas_equalTo(30);
//            make.width.mas_equalTo(60+10);
//        }];

        [self.backView addSubview:self.searchTF];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.backView.mas_left);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.height.mas_equalTo(30);
        }];

    }
    return self;
}

- (void)chooseButtonTapped {
    if (self.chooseType) {
        self.chooseType();
    }
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (UIButton *)chooseButton {
    
    if (!_chooseButton) {

        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"全部" titleColor:UIColorFromHEX(0x999999, 1) backgroundColor:UIColorFromHEX(0xf8f8f8, 1) backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        [_chooseButton addTarget:self action:@selector(chooseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_chooseButton setImage:[UIImage imageNamed:@"search-triangle"] forState:UIControlStateNormal];

        CGFloat spacing = 25;
        CGSize imageSize = _chooseButton.imageView.frame.size;
        _chooseButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing + 10, 0.0, 0.0);
        CGSize titleSize = _chooseButton.titleLabel.frame.size;
        _chooseButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing - 20);

    }
    return _chooseButton;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x666666, 1) placeholder:@"请输入关键词" BorderStyle:UITextBorderStyleNone];
        _searchTF.backgroundColor = UIColorFromHEX(0xf8f8f8, 1);
        [_searchTF setTintColor:END_COLOR];
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        //设置显示模式为永远显示(默认不显示)
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消" titleColor:UIColorFromHEX(0x333333, 1) backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.clipsToBounds = YES;
        _backView.layer.cornerRadius = 3.0f;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
#pragma mark -- override
- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:[super intrinsicContentSize]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
