//
//  BATAddressManageView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddressManageView.h"

@implementation BATAddressManageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    [self addSubview:self.addNewAddressButton];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.addNewAddressButton.mas_top);
    }];
    
    [self.addNewAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.equalTo(self);
        make.height.mas_offset(58);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.estimatedRowHeight = 100;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIButton *)addNewAddressButton
{
    if (_addNewAddressButton == nil) {
        _addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNewAddressButton setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_addNewAddressButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_addNewAddressButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xf75858, 1)] forState:UIControlStateNormal];
        
        _addNewAddressButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _addNewAddressButton;
}


@end
