//
//  BATPayOTCView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPayOTCView.h"

@implementation BATPayOTCView

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
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.tableFooterView = self.tableFooterView;

    }
    return _tableView;
}

- (BATConfirmPayFooterView *)tableFooterView
{
    if (_tableFooterView == nil) {
        _tableFooterView = [[BATConfirmPayFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.0f)];
    }
    return _tableFooterView;
}

@end
