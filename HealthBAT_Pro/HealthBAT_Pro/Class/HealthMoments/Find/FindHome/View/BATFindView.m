//
//  BATFindView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindView.h"

@implementation BATFindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, (1.0 / [UIScreen mainScreen].scale))];
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

@end
