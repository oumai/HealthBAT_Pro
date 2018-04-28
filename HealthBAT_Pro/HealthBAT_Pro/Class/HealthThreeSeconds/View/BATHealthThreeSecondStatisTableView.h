//
//  BATHealthThreeSecondStatisTableView.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthThreeSecondStatisticsModel.h"

@class BATHealthThreeSecondStatisTableView;
@protocol BATHealthThreeSecondStatisTableViewDelegate <NSObject>
- (void)healthThreeSecondStatisTableViewHeaderRefresh:(BATHealthThreeSecondStatisTableView *)statisTableView;
@end

@interface BATHealthThreeSecondStatisTableView : UITableView
@property (nonatomic ,weak) id<BATHealthThreeSecondStatisTableViewDelegate> bat_Delegate;
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (void)updateDataWith:(BATHealthThreeSecondStatisticsModel *)statisticsModel;
@end
