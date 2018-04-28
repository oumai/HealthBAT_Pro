//
//  BATSendDynamicViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSendDynamicView.h"

@interface BATWriteSymptomController : UIViewController

@property (nonatomic,strong) BATSendDynamicView *sendDynamicView;

@property (nonatomic,strong) NSString *DoctorID;

@property (nonatomic,assign) BATDoctorStudioOrderType OrderType;

@property (nonatomic,strong) NSString *OrderMoney;

//医生名字，照片，科室
@property (nonatomic,strong) NSString *doctorName;
@property (nonatomic,strong) NSString *doctorPhotoPath;
@property (nonatomic,strong) NSString *dept;

@end
