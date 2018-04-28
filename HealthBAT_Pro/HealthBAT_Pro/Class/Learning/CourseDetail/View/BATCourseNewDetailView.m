//
//  BATCourseNewDetailView.m
//  HealthBAT_Pro
//
//  Created by ; on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseNewDetailView.h"

@implementation BATCourseNewDetailView

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
    [self addSubview:self.courseDetailBottomView];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
    }];
    
    [self.courseDetailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(50);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (BATCourseDetailHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        
        float offsetHeight = 9 * SCREEN_WIDTH / 16;
        
        _tableHeaderView = [[BATCourseDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68 + offsetHeight)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}

- (BATCourseDetailBottomView *)courseDetailBottomView
{
    if (_courseDetailBottomView == nil) {
        _courseDetailBottomView = [[BATCourseDetailBottomView alloc] init];
        _courseDetailBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _courseDetailBottomView;
}

@end
