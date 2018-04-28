//
//  BATAddProgramSelectTimeView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddProgramSelectTimeView : UIView

/**
 时间pickerview
 */
@property (nonatomic,strong) UIPickerView *pickerView;

/**
 小时label
 */
@property (nonatomic,strong) UILabel *hourLabel;

/**
 分钟label
 */
@property (nonatomic,strong) UILabel *minuteLabel;

@end
