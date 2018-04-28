//
//  BATDoctorScheduleViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorScheduleView.h"

@interface BATDoctorScheduleViewController : UIViewController

@property (nonatomic,strong) BATDoctorScheduleView *doctorScheduleView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) ConsultType type;

/**
 *  医生ID
 */
@property (nonatomic,strong) NSString *doctorId;

/**
 *  价格
 */
@property (nonatomic,strong) NSString *momey;

/**
 *  医生名称
 */
@property (nonatomic,strong) NSString *doctorName;

/**
 *  科室
 */
@property (nonatomic,strong) NSString *departmentName;

/**
 *  是否是义诊
 */
@property (nonatomic,assign) BOOL IsFreeClinicr;

/**
 *  路劲
 */
@property (nonatomic,strong) NSString *pathName;

@end
