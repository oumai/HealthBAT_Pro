//
//  HospitalRegisterViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorModel.h"
#import "BATDutyModel.h"

@interface BATRegisterHospitalRegisterViewController : UIViewController

//@property (nonatomic,strong) BATDoctorData *doctor;
@property (nonatomic,assign) NSInteger hospitalID;
@property (nonatomic,copy)   NSString *hospitalName;
@property (nonatomic,strong) NSString *treatmenName;

@property (nonatomic,assign) NSInteger doctorID;
@property (nonatomic,copy)   NSString *doctorName;

@property (nonatomic,assign) NSInteger departmentID;
@property (nonatomic,copy)   NSString *departmentName;

@property (nonatomic,copy)   NSString *ZCID;
@property (nonatomic,strong) BATDutyData   *duty;

@end
