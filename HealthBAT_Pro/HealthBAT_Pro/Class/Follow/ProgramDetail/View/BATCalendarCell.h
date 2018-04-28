//
//  BATCalendarCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BATCalendarCell : UITableViewCell
/** 所有打卡日期 */
@property (nonatomic, strong) NSMutableArray *datesSelected;
/** 第一次打卡及最后一次打卡记录 */
@property (nonatomic, strong) NSMutableArray *ClockFirstAndLastDate;
@end
