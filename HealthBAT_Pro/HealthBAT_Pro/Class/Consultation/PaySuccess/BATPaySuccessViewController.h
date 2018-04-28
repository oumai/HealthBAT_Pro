//
//  BATPaySuccessViewController.h
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPaySuccessView.h"
//#import "DoctorListModel.h"
#import "BATDiseaseDescriptionModel.h"

@interface BATPaySuccessViewController : UIViewController

/**
 *  view
 */
@property (nonatomic,strong) BATPaySuccessView *paySuccessView;

/**
 *  咨询类型
 */
@property (nonatomic,assign) ConsultType type;

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


///**
// *  医生ID
// */
//@property (nonatomic,copy) NSString  *accountID;
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
//
///**
// *  病情单
// */
//@property (nonatomic,strong) BATDiseaseDescriptionModel *diseaseDescriptionModel;

@end
