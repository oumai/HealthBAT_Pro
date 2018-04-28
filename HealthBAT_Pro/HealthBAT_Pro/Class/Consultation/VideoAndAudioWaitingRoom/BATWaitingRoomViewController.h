//
//  BATWaitingRoomViewController.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 2016/10/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATTIMManager.h"
#import "BATNewMessageModel.h"

@interface BATWaitingRoomViewController : UIViewController<TIMMessageListener>

@property (nonatomic,assign) DoctorServerType type;
@property (nonatomic,assign) NSInteger roomID;
@property (nonatomic,copy)   NSString *doctorID;
@property (nonatomic,assign) NSInteger Gender;

@end
