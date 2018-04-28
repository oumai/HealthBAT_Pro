//
//  BATServiceRecordView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATServiceRecordView.h"

@implementation BATServiceRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
        _tableView.tableFooterView = [UIView new];
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
