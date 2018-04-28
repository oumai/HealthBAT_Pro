//
//  BATFamilyDoctorChatViewController.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface BATFamilyDoctorChatViewController : RCConversationViewController

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *DoctorId;

@property (nonatomic, copy) NSString *DoctorPhotoPath;

@end
