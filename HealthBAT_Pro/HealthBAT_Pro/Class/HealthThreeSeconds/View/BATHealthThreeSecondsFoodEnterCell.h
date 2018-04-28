//
//  BATHealthThreeSecondsFoodEnterCell.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATHealthThreeSecondsRecommedFoodListModel,BATHealthThreeSecondsDetailListModel;
@interface BATHealthThreeSecondsFoodEnterCell : UITableViewCell
@property (nonatomic, strong)BATHealthThreeSecondsRecommedFoodListModel *recommedFoodModel;
@property (nonatomic, strong)BATHealthThreeSecondsDetailListModel *threeSecondsDetailListModel;
@end
