//
//  BATHealthThreeSecondsDrinkWateRecordCell.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondsDrinkWateRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wateCountLabel;
@property(nonatomic, copy)void(^drinkWateRecordInfoBlock)();
@property(nonatomic, copy)void(^drinkWateButtonBlock)(NSInteger wateCount);
@property (nonatomic, assign) NSInteger drinkingWaterCount;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@end
