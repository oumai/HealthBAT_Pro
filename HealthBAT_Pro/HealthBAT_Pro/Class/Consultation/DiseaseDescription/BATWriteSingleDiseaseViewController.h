//
//  WriteSingleDiseaseViewController.h
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATWriteSingleDiseaseView.h"

@interface BATWriteSingleDiseaseViewController : UIViewController

/**
 *  view
 */
@property (nonatomic,strong) BATWriteSingleDiseaseView *writeSingleDiseaseView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) ConsultType type;

/**
 *  医生ID
 */
@property (nonatomic,strong) NSString *doctorID;

/**
 *  价格
 */
@property (nonatomic,strong) NSString *momey;

/**
 *  是否是义诊
 */
@property (nonatomic,assign) BOOL IsFreeClinicr;

@property (nonatomic,strong) NSString *pathName;

///**
// *  医生ID
// */
//@property (nonatomic,copy) NSString  *AccountID;
//
///**
// *  医生名字
// */
//@property (nonatomic,copy) NSString *doctorName;
//
///**
// *  医生头像
// */
//@property (nonatomic,copy) NSString *doctiorPhotoPath;

@end
