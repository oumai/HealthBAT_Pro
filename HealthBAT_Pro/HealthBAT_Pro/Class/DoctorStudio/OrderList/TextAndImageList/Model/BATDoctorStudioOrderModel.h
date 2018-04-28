//
//  BATDoctorStudioOrderModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorStudioOrderData;
@interface BATDoctorStudioOrderModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy) NSArray<DoctorStudioOrderData *> *Data;

@end

@interface DoctorStudioOrderData : NSObject

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

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, assign) BATDoctorStudioOrderType OrderType;

@property (nonatomic, assign) BATDoctorStudioCommentStatus IsComment;

@property (nonatomic, assign) BATDoctorStudioConsultStatus ConsultStatus;

@property (nonatomic, assign) BATDoctorStudioPayStatus OrderPayStatus;

@property (nonatomic, assign) BATDoctorStudioOrderStatus OrderStatus;

@end

