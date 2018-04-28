//
//  BATHealthFollowView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowView.h"

@implementation BATHealthFollowView

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

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self.tableHeaderView addSubview:self.healthFollowSearchView];
    [self.tableHeaderView addSubview:self.healthFollowMenuView];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.healthFollowSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.tableHeaderView);
        make.height.mas_equalTo(50);
    }];
    
    [self.healthFollowMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.tableHeaderView);
        make.top.equalTo(self.healthFollowSearchView.mas_bottom).offset(10);
        make.bottom.equalTo(self.tableHeaderView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        _tableHeaderView.backgroundColor = UIColorFromRGB(244, 244, 244, 1);
    }
    return _tableHeaderView;
}

- (BATHealthFollowSearchView *)healthFollowSearchView
{
    if (_healthFollowSearchView == nil) {
        _healthFollowSearchView = [[BATHealthFollowSearchView alloc] init];
    }
    return _healthFollowSearchView;
}

- (BATHealthFollowMenuView *)healthFollowMenuView
{
    if (_healthFollowMenuView == nil) {
        _healthFollowMenuView = [[BATHealthFollowMenuView alloc] init];
        _healthFollowMenuView.backgroundColor = [UIColor whiteColor];
    }
    return _healthFollowMenuView;
}

@end
