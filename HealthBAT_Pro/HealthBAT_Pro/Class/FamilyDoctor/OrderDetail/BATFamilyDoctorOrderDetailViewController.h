//
//  BATFamilyDoctorOrderDetailViewController.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFamilyDoctorOrderDetailViewController : UIViewController

@property (nonatomic,strong) NSString *orderNo;

@property (nonatomic,assign) BATFamilyDoctorOrderState OrderStateShow;

@property (nonatomic,assign) BOOL paySuccess;

@end
