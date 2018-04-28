//
//  BATAddressListView.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddressListView : UIView

/**
 *  地址列表
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 添加新收货地址
 */
@property (nonatomic,strong) UIButton *addNewAddressButton;

@end
