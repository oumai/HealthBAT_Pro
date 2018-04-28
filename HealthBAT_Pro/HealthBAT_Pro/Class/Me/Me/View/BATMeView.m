//
//  BATMeView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMeView.h"

@implementation BATMeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = UIColorFromRGB(227, 227, 228, 1);
        _tableView.bounces = NO;

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        [self addSubview:_tableView];
        
        [self setupConstraints];
        
        _userInfoView = [[BATUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 369*0.5+20)];
        _tableView.tableHeaderView = _userInfoView;
        
    }
    return self;
}

#pragma mark private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
