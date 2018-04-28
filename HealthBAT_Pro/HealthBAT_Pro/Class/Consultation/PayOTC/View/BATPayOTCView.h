//
//  BATPayOTCView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATConfirmPayFooterView.h"

@interface BATPayOTCView : UIView

@property (nonatomic, strong) UITableView *tableView;

/**
 *  tableFooterView
 */
@property (nonatomic,strong) BATConfirmPayFooterView *tableFooterView;

@end
