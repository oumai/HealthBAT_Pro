//
//  BATDoctorListViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorListView.h"
#import "BATDoctorSortView.h"
#import "BATDoctorFilterView.h"

@interface BATDoctorListViewController : UIViewController

@property (nonatomic,strong) BATDoctorListView *doctorListView;

@property (nonatomic,strong) UIControl *control;

@property (nonatomic,strong) BATDoctorSortView *doctorSortView;

@property (nonatomic,strong) BATDoctorFilterView *filterView;

@end
