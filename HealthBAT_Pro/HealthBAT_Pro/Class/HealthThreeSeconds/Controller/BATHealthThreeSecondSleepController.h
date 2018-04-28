//
//  BATHealthThreeSecondSleepController.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureButtonBlock)(NSDictionary *timeDict);
@interface BATHealthThreeSecondSleepController : UIViewController
- (instancetype)initWithSelectedDate:(NSString *)selectedDate bedTime:(NSString *)bedTime getUpTime:(NSString *)getUpTime makeSureComplete:(sureButtonBlock)sureButtonBlock;
@end
