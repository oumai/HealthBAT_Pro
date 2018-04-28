//
//  BATPaySuccessView.m
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATPaySuccessView.h"
#import "Masonry.h"

@implementation BATPaySuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_tableView];

        [self setupConstraints];

        _paySuccessHeaderView = [[BATPaySuccessHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 144.5)];
        _tableView.tableHeaderView = _paySuccessHeaderView;

        _paySuccessFooterView = [[BATPaySuccessFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, 95.0f)];
        _tableView.tableFooterView = _paySuccessFooterView;

        [_paySuccessFooterView.callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark Action
- (void)callBtnAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(paySuccessViewCallBtnClickedAction)]) {
        [_delegate paySuccessViewCallBtnClickedAction];
    }
}

@end
