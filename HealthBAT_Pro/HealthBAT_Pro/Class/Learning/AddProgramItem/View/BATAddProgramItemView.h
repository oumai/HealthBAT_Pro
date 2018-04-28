//
//  BATAddProgramItemView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
typedef void(^ButtonHandle)(void);

@interface BATAddProgramItemView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *tableFooterView;

/**
 删除按钮
 */
@property (nonatomic,strong) BATGraditorButton *button;

/**
 删除Block
 */
@property (nonatomic,strong) ButtonHandle buttonHandle;

@end
