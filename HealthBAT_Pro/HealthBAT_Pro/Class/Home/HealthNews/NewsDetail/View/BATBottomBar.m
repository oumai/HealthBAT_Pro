//
//  BATBottomBar.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/18.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATBottomBar.h"

@implementation BATBottomBar

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = UIColorFromHEX(0Xfcfcfc, 1);
        

        WEAK_SELF(self);
        
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(@5);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];

        [self addSubview:self.collectionButton];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.shareButton.mas_left).offset(-10);
            make.centerY.equalTo(self.shareButton.mas_centerY);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];


        [self addSubview:self.reviewButton];
        [self.reviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.right.equalTo(self.collectionButton.mas_left).offset(-10);
            make.centerY.equalTo(self.shareButton.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(40);

        }];


        [self addSubview:self.editButton];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.shareButton.mas_centerY);
            make.right.greaterThanOrEqualTo(self.reviewButton.mas_left).offset(-25);
            make.height.mas_equalTo(30);
        }];

    }
    return self;
}

- (UIButton *)editButton {

    if (!_editButton) {

        _editButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"写评论..." titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:[UIColor whiteColor] backgroundImage:nil Font:[UIFont systemFontOfSize:12]];
        _editButton.layer.cornerRadius = 15;
        _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _editButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _editButton.layer.borderWidth = 0.5;
        _editButton.layer.borderColor = BASE_LINECOLOR.CGColor;

        WEAK_SELF(self);
        [_editButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.editBlock) {
                self.editBlock();
            }
        }];
    }
    return _editButton;
}

- (UIButton *)reviewButton {

    if (!_reviewButton) {

        _reviewButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:nil Font:nil];
        [_reviewButton setImage:[UIImage imageNamed:@"icon-pl"] forState:UIControlStateNormal];
        _reviewButton.imageView.clipsToBounds = NO;
        WEAK_SELF(self);
        [_reviewButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.reviewBlock) {
                self.reviewBlock();
            }
        }];

    }
    return _reviewButton;
}


- (UIButton *)collectionButton {

    if (!_collectionButton) {

        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:nil Font:nil];
        [_collectionButton setImage:[UIImage imageNamed:@"icon-sc"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"icon-sc-d"] forState:UIControlStateSelected];

        WEAK_SELF(self);
        [_collectionButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.collectionBlock) {
                self.collectionBlock();
            }
        }];

    }
    return _collectionButton;
}


- (UIButton *)shareButton {

    if (!_shareButton) {

        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom Title:nil titleColor:nil backgroundColor:nil backgroundImage:nil Font:nil];
//        [_shareButton setImage:[UIImage imageNamed:@"home-share-icon"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"icon-fenxiang"] forState:UIControlStateNormal];
        WEAK_SELF(self);
        [_shareButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.shareBlock) {
                self.shareBlock();
            }
        }];

    }
    return _shareButton;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
