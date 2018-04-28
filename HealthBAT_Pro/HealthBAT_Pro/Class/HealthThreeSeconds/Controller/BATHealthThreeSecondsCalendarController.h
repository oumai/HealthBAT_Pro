//
//  BATHealthThreeSecondsCalendarController.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondsCalendarController : UIViewController
/** 默认选中的日期 */
@property (nonatomic, copy) NSString  *selectedDateStr;
@property (nonatomic, copy)void(^backBlock)(NSString *selDate);
@end
