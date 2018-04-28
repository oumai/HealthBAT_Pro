//
//  BATCallViewController.h
//  HealthBAT_Doctor
//
//  Created by cjl on 2017/5/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCallView.h"

@interface BATCallViewController : UIViewController

@property (nonatomic,strong) NSString *doctorPic;

@property (nonatomic,strong) NSString *doctorName;//医生姓名
@property (nonatomic,strong) NSString *hospitalName;//医院名字
@property (nonatomic,strong) NSString *departmentName;//科室名称
@property (nonatomic,strong) NSString *doctorTitle;//医生级别

@property (nonatomic,strong) NSString *orderNo;

@property (nonatomic,strong) NSString *roomID;

@property (nonatomic,strong) NSString *channelKey;

@property (nonatomic,strong) BATCallView *callView;

@property (nonatomic,assign) BATCallState callState;

@property (nonatomic,copy) NSString *doctorID;

@end
