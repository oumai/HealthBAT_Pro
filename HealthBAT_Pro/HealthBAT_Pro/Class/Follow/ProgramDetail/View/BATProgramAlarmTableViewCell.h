//
//  BATProgramAlarmTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/2/2.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlarmBlock)(BOOL flag);

@interface BATProgramAlarmTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UISwitch *alarmSwitch;

@property (nonatomic,strong) AlarmBlock alarmBlock;

@end
