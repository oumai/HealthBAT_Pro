//
//  BATDoctorScheduleConfrimView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleConfrimView.h"

@implementation BATDoctorScheduleConfrimView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = 45;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self setupConstraints];
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = _footerView;

//        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _confirmButton.frame = CGRectMake(10, 40, SCREEN_WIDTH - 20.0f, 40);
//        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
//        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_confirmButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
//        _confirmButton.layer.cornerRadius = 6.0f;
//        _confirmButton.layer.masksToBounds = YES;
//        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        _confirmButton = [[BATGraditorButton alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20.0f, 40)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal] ;
        _confirmButton.enablehollowOut = YES;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirmButton.titleColor = [UIColor whiteColor];
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = 6.f;
        [_confirmButton setGradientColors:@[START_COLOR,END_COLOR]];
        
        [_footerView addSubview:_confirmButton];

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
