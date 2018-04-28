//
//  BATHealthFollowTestView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowTestView.h"

@implementation BATHealthFollowTestView

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
- (void)submitButtonAction:(UIButton *)button
{
    if (self.submitAction) {
        self.submitAction();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self.tableFooterView addSubview:self.submitButton];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(175, 45));
        make.center.equalTo(self.tableFooterView);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.tableFooterView;
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

- (BATGraditorButton *)submitButton
{
    if (_submitButton == nil) {
        _submitButton = [[BATGraditorButton alloc]init];
        [_submitButton setTitle:@"提   交" forState:UIControlStateNormal];
        _submitButton.titleColor = [UIColor whiteColor];
        _submitButton.enablehollowOut = YES;
//        [_submitButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
        [_submitButton  setGradientColors:@[START_COLOR,END_COLOR]];
//        [_submitButton setTitleColor:UIColorFromHEX(0xfffefe, 1) forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitButton.layer.cornerRadius = 6.0f;
        _submitButton.layer.masksToBounds = YES;
    }
    return _submitButton;
}

@end
