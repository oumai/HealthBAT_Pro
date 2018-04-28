//
//  BATPayOTCViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPayOTCView.h"

@interface BATPayOTCViewController : UIViewController

@property (nonatomic,strong) BATPayOTCView *payOTCView;

/**
 订单编号
 */
@property (nonatomic,copy) NSString *OrderNo;

/**
 订单总价
 */
@property (nonatomic, copy) NSString *TotalFee;

@end
