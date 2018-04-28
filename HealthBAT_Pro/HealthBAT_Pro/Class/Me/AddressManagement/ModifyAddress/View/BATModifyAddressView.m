//
//  BATModifyAddressView.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATModifyAddressView.h"

@interface BATModifyAddressView ()

@property (nonatomic,strong) UIView *footView;

@end

@implementation BATModifyAddressView

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
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
//        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (UIView *)footView
{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        [_footView addSubview:self.saveAddressBtn];
    }
    return _footView;
}

- (BATGraditorButton *)saveAddressBtn
{
    if (_saveAddressBtn == nil) {
        _saveAddressBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        _saveAddressBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 40);
        [_saveAddressBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        _saveAddressBtn.titleColor = [UIColor whiteColor];
        _saveAddressBtn.enablehollowOut = YES;
        [_saveAddressBtn setGradientColors:@[START_COLOR,END_COLOR]];
        
        _saveAddressBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _saveAddressBtn.layer.cornerRadius = 6;
        _saveAddressBtn.layer.masksToBounds = YES;
    }
    return _saveAddressBtn;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
