//
//  BATHealthThreeSecondsDetailTopInfoView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/22.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATHealthThreeSecondsTopChangeDateView.h"

@interface BATHealthThreeSecondsDetailTopInfoView : UIView
@property (nonatomic, strong) BATHealthThreeSecondsTopChangeDateView *topChangeDateVieW;
@property (nonatomic, assign) double  calorieValue;

/** <#属性描述#> */
@property (nonatomic, copy) void (^editButtonBlock)();
@end
