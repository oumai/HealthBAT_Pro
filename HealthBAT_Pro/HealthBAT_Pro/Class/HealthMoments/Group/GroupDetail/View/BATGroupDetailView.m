//
//  BATGroupDetailView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupDetailView.h"

@implementation BATGroupDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 250;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        [self setupConstraints];
        
        _headerView = [[BATGroupDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 188)];
        _tableView.tableHeaderView = _headerView;
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

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

@end
