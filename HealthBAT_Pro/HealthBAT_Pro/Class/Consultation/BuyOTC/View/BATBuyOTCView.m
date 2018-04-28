//
//  BATBuyOTCView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBuyOTCView.h"

@interface BATBuyOTCView ()

@end

@implementation BATBuyOTCView

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
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.tableFooterView = self.footView;

    }
    return _tableView;
}

- (UIView *)footView
{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        [_footView addSubview:self.payBtn];
    }
    return _footView;
}

- (BATGraditorButton *)payBtn
{
    if (_payBtn == nil) {
        _payBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 40);
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _payBtn.titleColor = [UIColor whiteColor];
        _payBtn.enablehollowOut = YES;
        [_payBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _payBtn.layer.cornerRadius = 3;
        _payBtn.layer.masksToBounds = YES;
    }
    return _payBtn;
}


@end
