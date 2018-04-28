//
//  BATDoctorStudioChatViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/112017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface BATDoctorStudioChatViewController : RCConversationViewController

@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSString *IllnessDescription;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,assign) BATDoctorStudioConsultStatus status;
@property (nonatomic,copy) NSString *doctorName;
@property (nonatomic,copy) NSString *patientName;

@end
