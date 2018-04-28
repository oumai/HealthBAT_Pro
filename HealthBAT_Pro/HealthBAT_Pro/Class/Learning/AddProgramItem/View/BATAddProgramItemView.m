//
//  BATAddProgramItemView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddProgramItemView.h"

@implementation BATAddProgramItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Action
- (void)buttonAction:(UIButton *)button
{
    if (self.buttonHandle) {
        self.buttonHandle();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self.tableFooterView addSubview:self.button];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 45));
        make.center.equalTo(self.tableFooterView);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = self.tableFooterView;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _tableView;
}

- (UIView *)tableFooterView
{
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _tableFooterView;
}

- (BATGraditorButton *)button
{
    if (_button == nil) {
        _button = [[BATGraditorButton alloc]init];
        _button.titleColor = [UIColor whiteColor];
        _button.enablehollowOut = YES;
        [_button setGradientColors:@[START_COLOR,END_COLOR]];
     //   [_button setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
     //   [_button setTitleColor:UIColorFromHEX(0xfffefe, 1) forState:UIControlStateNormal];
        [_button setTitle:@"删 除" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _button.titleLabel.font = [UIFont systemFontOfSize:18];
        _button.layer.cornerRadius = 6.0f;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}

@end
