//
//  BATAddressManageView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddressManageView : UIView

/**
 *  地址列表
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 添加新收货地址
 */
@property (nonatomic,strong) UIButton *addNewAddressButton;

@end
