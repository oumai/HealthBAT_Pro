//
//  BATDrKangDetailView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/2/212017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangDetailView.h"

@implementation BATDrKangDetailView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = UIColorFromHEX(0x323232,0.8);

        [self addSubview:self.downButton];
        [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@140);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(@40);
        }];

        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downButton.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];

        [self addSubview:self.detailTextView];
        [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downButton.mas_bottom).offset(10);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

- (UIButton *)downButton {

    if (!_downButton) {

        WEAK_SELF(self);
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.backgroundColor = [UIColor whiteColor];
        [_downButton setImage:[UIImage imageNamed:@"icon-tk"] forState:UIControlStateNormal];
        [_downButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.downBlock) {
                self.downBlock();
            }
        }];
    }
    return _downButton;
}

- (UIView *)backView {

    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UITextView *)detailTextView {

    if (!_detailTextView) {

        _detailTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _detailTextView.editable = NO;
    }
    return _detailTextView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
