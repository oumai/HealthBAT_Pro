//
//  BATDoctorSortView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorSortFooterView.h"

@interface BATDoctorSortView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BATDoctorSort doctorSort;

@property (nonatomic,strong) BATDoctorSortFooterView *doctorSortFooterView;

@end
