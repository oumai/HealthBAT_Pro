//
//  BATProgramDetailView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramDetailView.h"

@implementation BATProgramDetailView

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

#pragma mark - Action
- (void)punchCardButtonAction:(UIButton *)button
{
    button.selected = YES;
    button.userInteractionEnabled = NO;
    if (self.punchCardBlock) {
        self.punchCardBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self addSubview:self.taskStateButton];
    [self addSubview:self.punchCardButton];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
        
    }];
    
    [self.taskStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        if (iPhoneX) {
            if (@available(iOS 11.0, *)) {
                make.height.mas_offset(57.5 + 34);
            }
        } else {
            make.height.mas_offset(57.5);
        }
        
    }];
    
    [self.punchCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        if (iPhoneX) {
            if (@available(iOS 11.0, *)) {
                make.height.mas_offset(57.5 + 34);
            }
        } else {
            make.height.mas_offset(57.5);
        }
        
    }];
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 110;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (BATProgramDetailHeaderView *)headerView
{
    if (_headerView == nil) {
        if(@available(iOS 11.0, *)) {
            _headerView = [[BATProgramDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
        }
        else {
            _headerView = [[BATProgramDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 - 64)];
        }
    }
    return _headerView;
}

- (UIButton *)taskStateButton
{
    if (_taskStateButton == nil) {
        _taskStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_taskStateButton setTitle:@"任务进行中" forState:UIControlStateNormal];
        [_taskStateButton setBackgroundImage:[Tools imageFromColor:STRING_LIGHT_COLOR] forState:UIControlStateNormal];
        _taskStateButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_taskStateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _taskStateButton.hidden = YES;
        
        if (iPhoneX) {
            [_taskStateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 17, 0)];
        }
    }
    return _taskStateButton;
}

- (UIButton *)punchCardButton
{
    if (_punchCardButton == nil) {
        _punchCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_punchCardButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x6ccc56, 1)] forState:UIControlStateNormal];
         [_punchCardButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xC8C8C8, 1)] forState:UIControlStateSelected];
        
        _punchCardButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_punchCardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _punchCardButton.hidden = YES;
        [_punchCardButton addTarget:self action:@selector(punchCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_punchCardButton setTitle:@"打卡" forState:UIControlStateNormal];
        [_punchCardButton setTitle:@"任务完成" forState:UIControlStateSelected];
        if (iPhoneX) {
            [_punchCardButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 17, 0)];
        }
    }
    return _punchCardButton;
}

@end
