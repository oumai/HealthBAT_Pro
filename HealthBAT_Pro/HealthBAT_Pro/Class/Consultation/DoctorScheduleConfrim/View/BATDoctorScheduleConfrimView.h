//
//  BATDoctorScheduleConfrimView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

@interface BATDoctorScheduleConfrimView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *footerView;

//@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) BATGraditorButton *confirmButton;

@end
