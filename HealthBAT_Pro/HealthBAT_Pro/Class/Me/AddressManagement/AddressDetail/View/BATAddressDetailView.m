//
//  AddressDetailView.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressDetailView.h"

@implementation BATAddressDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 50.0f) style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.frame) - 50.0f, CGRectGetWidth(self.frame), 50.0f)];
        _footView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_footView];
        
        _defaultAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultAddressBtn setFrame:_footView.bounds];
        [_defaultAddressBtn setTitle:@"设置默认地址" forState:UIControlStateNormal];
        [_defaultAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_defaultAddressBtn setBackgroundImage:[Tools imageFromColor:[UIColor orangeColor]] forState:UIControlStateNormal];
        _defaultAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footView addSubview:_defaultAddressBtn];
        
    }
    return self;
}

@end
