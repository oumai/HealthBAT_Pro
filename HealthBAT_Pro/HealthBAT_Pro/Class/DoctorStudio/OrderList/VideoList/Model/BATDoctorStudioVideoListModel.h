//
//  BATDoctorStudioVideoListModel.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class DoctorStudioVideoOrderData;

@interface BATDoctorStudioVideoListModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy) NSArray<DoctorStudioVideoOrderData *> *Data;

@end

@interface DoctorStudioVideoOrderData : NSObject

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, assign) NSInteger OrderServerTime;

@property (nonatomic, copy) NSString *OrderExpireTime;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *DoctorPic;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *IllnessDescription;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *OrderServerName;

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *Images;

@property (nonatomic, copy) NSString *OrderMoney;

@property (nonatomic, copy) NSString *RoomID;

@property (nonatomic, copy) NSString *ConsultTime;

@property (nonatomic, assign) BOOL IsComment;

@property (nonatomic, assign) BATDoctorStudioOrderStatus OrderStatus;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *EndTime;

@property (nonatomic, copy) NSString *StartTime;

@property (nonatomic, copy) NSString *ScheduleId;

@property (nonatomic, copy) NSString *ScheduleDate;

@property (nonatomic, copy) NSString *DepartmentName;
@property (nonatomic, copy) NSString *HospitalName;
@property (nonatomic, copy) NSString *DoctorTitle;

@property (nonatomic, assign) BOOL CanEnterRoom;

@property (nonatomic, assign) BATDoctorStudioConsultStatus ConsultStatus;

@property (nonatomic, assign) BATDoctorStudioOrderType OrderType;

@property (nonatomic, assign) BATDoctorStudioPayStatus OrderPayStatus;

@end
