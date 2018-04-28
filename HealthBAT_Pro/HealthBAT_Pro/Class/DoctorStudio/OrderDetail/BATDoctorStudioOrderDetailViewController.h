//
//  BATDoctorStudioOrderDetailViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 17/6/202017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorStudioOrderDetailViewController : UIViewController

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign) BATDoctorStudioOrderType type;
@property (nonatomic,assign) BATDoctorStudioPayStatus payStatus;
@property (nonatomic,copy) NSString *price;

@property (nonatomic,assign) BATDoctorStudioOrderStatus orderStatus;

@end
