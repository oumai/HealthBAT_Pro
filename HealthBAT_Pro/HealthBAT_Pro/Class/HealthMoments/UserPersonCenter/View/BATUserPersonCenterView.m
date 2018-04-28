//
//  BATUserPersonCenterView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATUserPersonCenterView.h"

@implementation BATUserPersonCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _userInfoView = [[BATUserPersonCenterUserInfoView alloc] init];
        [self addSubview:_userInfoView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 250;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_tableView];
        
        [self setupConstraints];
        
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
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(166);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.bottom.left.equalTo(self);
        make.top.equalTo(_userInfoView.mas_bottom);
    }];
}

@end
