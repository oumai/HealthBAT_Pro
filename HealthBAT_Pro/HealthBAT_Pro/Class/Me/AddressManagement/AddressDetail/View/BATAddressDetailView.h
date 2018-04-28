//
//  AddressDetailView.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddressDetailView : UIView

/**
 *  单个地址信息展示
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  底部view
 */
@property (nonatomic,strong) UIView *footView;

/**
 *  默认地址按钮
 */
@property (nonatomic,strong) UIButton *defaultAddressBtn;

@end
