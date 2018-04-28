//
//  BATConsultationDoctorDetailViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultationDoctorDetailViewController : UIViewController

/**
 *  医生ID
 */
@property (nonatomic,strong) NSString *doctorID;

///**
// *  医生DoctorID
// */
//@property (nonatomic,strong) NSString *kmDoctorID;

/**
 *  是否为康美医生
 */
@property (nonatomic,assign) BOOL isKMDoctor;

@property (nonatomic,strong) NSString *pathName;

@property (nonatomic,assign) BOOL  isSaveOperate;

@end
