//
//  BATDiteGuideBottomSegementView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDiteGuideBottomSegementView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, copy) void (^leftButtonBlock)(UIButton *leftButton, UIButton *rightButton);
@property (nonatomic, copy) void (^rightButtonBlock)(UIButton *rightButton, UIButton *leftButton);
@end
