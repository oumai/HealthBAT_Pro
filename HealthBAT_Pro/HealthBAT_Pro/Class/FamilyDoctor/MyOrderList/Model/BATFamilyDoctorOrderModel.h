//
//  BATFamilyDoctorOrderModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

/*
 订单列表model
 */

@class BATFamilyDoctorOrderData;

@interface BATFamilyDoctorOrderModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATFamilyDoctorOrderData   *> *Data;

@end


@interface BATFamilyDoctorOrderData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, copy) NSString *RoomID;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *DoctorPic;

@property (nonatomic, copy) NSString *OrderServerType;

@property (nonatomic, assign) CGFloat OrderMoney;

@property (nonatomic, assign) NSInteger OrderStatus;

@property (nonatomic, assign) NSInteger OrderPayStatus;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *OrderExpireTime;

@property (nonatomic, assign) NSInteger OrderStatusShow;

@property (nonatomic, copy) NSString *LastModifiedTime;

@property (nonatomic, copy) NSString *ServerTime;

@property (nonatomic, assign) NSInteger OrderServerTime;

@property (nonatomic, copy) NSString *OrderServiceTimeEnum;

@property (nonatomic, copy) NSString *ConsultTime;

@property (nonatomic, copy) NSString *OrderServerName;

@property (nonatomic, copy) NSString *PhoneNumber;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *DoctorTitle;

@property (nonatomic,assign) BOOL IsComment;

@end

