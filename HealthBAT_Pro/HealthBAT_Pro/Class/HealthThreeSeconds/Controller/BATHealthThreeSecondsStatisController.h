//
//  BATHealthThreeSecondsStatisController.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthThreeSecondsModel.h"
@interface BATHealthThreeSecondsStatisController : UIViewController
- (instancetype)initWithModel:(BATHealthThreeSecondsModel *)model todayDate:(NSDate *)todayDate;
@end
