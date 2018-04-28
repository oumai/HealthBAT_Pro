//
//  BATNewConfirmPayView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewConfirmPayView.h"

@implementation BATNewConfirmPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self setupConstraints];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        
        _tableFooterView = [[BATNewPaybottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.0f)];
        _tableView.tableFooterView = _tableFooterView;
        
        [_tableFooterView.confirmPayBtn addTarget:self action:@selector(confirmPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
- (void)confirmPayBtnAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(confirmPayBtnClickedAction)]) {
        [_delegate confirmPayBtnClickedAction];
    }
}


@end
