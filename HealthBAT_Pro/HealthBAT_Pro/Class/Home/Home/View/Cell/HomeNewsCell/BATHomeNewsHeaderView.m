//
//  BATHomeNewsHeaderView.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewsHeaderView.h"

@implementation BATHomeNewsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        self.lastButton = self.recommendNewsView;

        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);

        [self addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];

        [self addSubview:self.hotNewsView];
        [self.hotNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(50);
        }];


        [self addSubview:self.recommendNewsView];
        [self.recommendNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.hotNewsView.mas_left).offset(-15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(50);
        }];


        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15-50-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self);
        }];

        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (void)categoryTapped:(UIButton *)sender {

    //逻辑
    [self categoryLogic:sender];

    //动画
    [self categoryButtonAnimate:sender];
}

- (void)categoryLogic:(UIButton *)sender {

    if (self.lastButton.tag == sender.tag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_REFRESH" object:nil userInfo:@{@"category":@(sender.tag)}];
    }
}

- (void)categoryButtonAnimate:(UIButton *)sender {


    if (self.categoryClickedBlock) {
        self.categoryClickedBlock(sender.tag);
    }

    self.lastButton.selected = NO;
    sender.selected = YES;

    self.lastButton = sender;

    [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {

        if (sender.tag == kHomeNewsHot) {
            make.right.equalTo(self.mas_right).offset(-10);
        }
        else if (sender.tag == kHomeNewsRecommend) {
            make.right.equalTo(self.mas_right).offset(-15-50-10);
        }
    }];

    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark - getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"健康资讯" titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
    }
    return _leftButton;
}


- (UIButton *)hotNewsView {

    if (!_hotNewsView) {
        _hotNewsView = [UIButton buttonWithType:UIButtonTypeCustom Title:@"热点" titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        [_hotNewsView setTitleColor:BASE_COLOR forState:UIControlStateSelected];
        [_hotNewsView addTarget:self action:@selector(categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        _hotNewsView.tag = kHomeNewsHot;
    }
    return _hotNewsView;
}

- (UIButton *)recommendNewsView {

    if (!_recommendNewsView) {
        _recommendNewsView = [UIButton buttonWithType:UIButtonTypeCustom Title:@"推荐" titleColor:UIColorFromHEX(0x666666, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:15]];
        [_recommendNewsView addTarget:self action:@selector(categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_recommendNewsView setTitleColor:BASE_COLOR forState:UIControlStateSelected];
        _recommendNewsView.selected = YES;
        _recommendNewsView.tag = kHomeNewsRecommend;

    }
    return _recommendNewsView;
}

- (UIView *)bottomLine {

    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = BASE_COLOR;
    }
    return _bottomLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
