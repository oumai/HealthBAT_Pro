//
//  BATDoctorStudioPaySuccessViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/112017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPaySuccessView.h"
//#import "BATDiseaseDescriptionModel.h"
#import "BATDoctorStudioValidatePayModel.h"

@interface BATDoctorStudioPaySuccessViewController : UIViewController


/**
 chatRoom信息
 */
@property (nonatomic,strong) BATDoctorStudioValidatePayModel *model;
/**
 *  view
 */
@property (nonatomic,strong) BATPaySuccessView *paySuccessView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) BATDoctorStudioOrderType type;

/**
 *  支付方式
 */
@property (nonatomic,strong) NSString *payType;

/**
 *  价格
 */
@property (nonatomic,strong) NSString  *momey;

/**
 *  订单编号
 */
@property (nonatomic,strong) NSString *orderNo;

@end
