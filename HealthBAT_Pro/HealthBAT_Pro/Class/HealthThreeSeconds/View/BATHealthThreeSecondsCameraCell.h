//
//  BATHealthThreeSecondsCameraCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondsCameraCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic, copy) void(^cameraButtonClick)();
@end
