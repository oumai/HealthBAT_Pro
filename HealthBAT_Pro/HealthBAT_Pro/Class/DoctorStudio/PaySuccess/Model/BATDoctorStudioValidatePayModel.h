//
//  BATDoctorStudioValidatePayModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/182017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class ChatRoomData;

@interface BATDoctorStudioValidatePayModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) ChatRoomData *Data;

@end

@interface ChatRoomData : NSObject

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *IllnessDescription;

@property (nonatomic, copy) NSString *Images;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *DoctorId;

@property (nonatomic, copy) NSString *DoctorPhotoPath;

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *PatientName;

@property (nonatomic, copy) NSString *PatientPhotoPath;

@property (nonatomic, copy) NSString *OrderServerName;

@property (nonatomic, assign) BATDoctorStudioOrderServiceType OrderServerType;

@property (nonatomic, assign) BATDoctorStudioOrderType OrderType;

@property (nonatomic, copy) NSString *RoomID;

@end
