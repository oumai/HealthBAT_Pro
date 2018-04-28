//
//  BATEatSearchAlert.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
typedef void(^EatSearchCancle)(void);
typedef void(^EatSearchComfirm)(void);
@interface BATEatSearchAlert : UIView

@property (copy, nonatomic) EatSearchCancle cancleBlock;
@property (copy, nonatomic) EatSearchComfirm comfirmBlock;

@property (nonatomic, strong) BATHealthThreeSecondsRecommedFoodListModel *recommendFoodModel;
@end
