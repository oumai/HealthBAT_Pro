//
//  BATBuyOTCView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATBuyOTCView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *footView;

/**
 *  支付按钮
 */
@property (nonatomic,strong) BATGraditorButton *payBtn;

@end
