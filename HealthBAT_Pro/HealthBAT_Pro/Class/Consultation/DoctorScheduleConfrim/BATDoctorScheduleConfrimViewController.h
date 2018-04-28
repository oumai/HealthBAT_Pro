//
//  BATDoctorScheduleConfrimViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorScheduleConfrimView.h"

@interface BATDoctorScheduleConfrimViewController : UIViewController

@property (nonatomic,strong) BATDoctorScheduleConfrimView *doctorScheduleConfrimView;

/**
 *  医生ID
 */
@property (nonatomic,strong) NSString *doctorID;

/**
 *  医生排版编号
 */
@property (nonatomic,strong) NSString *scheduleID;

/**
 *  咨询类型
 */
@property (nonatomic,assign) ConsultType type;

/**
 *  价格
 */
@property (nonatomic,strong) NSString *momey;

/**
 *  时间
 */
@property (nonatomic,strong) NSString *time;

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
 *  路径
 */
@property (nonatomic,strong) NSString  *pathName;

@end
