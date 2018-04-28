//
//  BATFreeClinicDoctorViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATFreeClinicDoctorView.h"

@interface BATFreeClinicDoctorViewController : UIViewController

@property (nonatomic,strong) BATFreeClinicDoctorView *freeClinicDoctorView;

@property (nonatomic,strong) NSString *pathName;
@end
