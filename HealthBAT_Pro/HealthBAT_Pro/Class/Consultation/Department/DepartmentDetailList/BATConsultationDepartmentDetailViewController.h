//
//  BATConsultationDepartmentDetailViewController.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultationDepartmentDetailViewController : UIViewController

/**
 *  科室名称
 */
@property (nonatomic,copy) NSString *departmentName;

/**
 *  是否为已经资讯的医生，默认为否
 */
@property (nonatomic,assign) BOOL isConsulted;

@property (nonatomic,strong) NSString *pathName;
@end
