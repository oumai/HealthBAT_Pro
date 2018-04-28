//
//  BATNewPayViewController.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATNewConfirmPayView.h"

@interface BATNewPayViewController : UIViewController

/**
 *  view
 */
@property (nonatomic,strong) BATNewConfirmPayView *confirmPayView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) BATDoctorStudioOrderType type;

/**
 *  订单编号,此页面生成
 */
@property (nonatomic,strong) NSString *orderNo;

/**
 *  价格
 */
@property (nonatomic,strong) NSString  *momey;

//医生名字，照片，科室
@property (nonatomic,strong) NSString *doctorName;
@property (nonatomic,strong) NSString *doctorPhotoPath;
@property (nonatomic,strong) NSString *dept;
@property (nonatomic,strong) NSString *doctorID;


//语音视频修改订单会传的参数
@property (nonatomic,copy) NSString *ScheduleId;
@property (nonatomic,copy) NSString *TimeStr;


//正常流程支付
@property (nonatomic,assign) BOOL isTheNormalProcess;

@end
