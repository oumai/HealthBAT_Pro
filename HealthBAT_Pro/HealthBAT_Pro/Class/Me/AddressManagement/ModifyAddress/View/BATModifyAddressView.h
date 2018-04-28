//
//  BATModifyAddressView.h
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATModifyAddressView : UIView

/**
 *  编辑地址信息view
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  保存地址按钮
 */
@property (nonatomic,strong) BATGraditorButton *saveAddressBtn;

/**
 *  地区选择器
 */
@property (nonatomic,strong) UIPickerView *pickerView;

@end
