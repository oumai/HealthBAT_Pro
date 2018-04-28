//
//  BATHealthThreeSecondsFoodEnterAlertView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATHealthThreeSecondsFoodEnterAlertView,BATHealthThreeSecondsRecommedFoodListModel;
#pragma mark - 协议

@protocol BATHealthThreeSecondsFoodEnterAlertViewDelegate <NSObject>

- (void)foodEnterAlertView:(BATHealthThreeSecondsFoodEnterAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end


@interface BATHealthThreeSecondsFoodEnterAlertView : UIView

@property (nonatomic,weak) id<BATHealthThreeSecondsFoodEnterAlertViewDelegate> delegate;
@property (nonatomic, strong)BATHealthThreeSecondsRecommedFoodListModel *recommedFoodModel;
- (void)show;
@end
