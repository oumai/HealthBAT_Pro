//
//  BATFamilyDoctorOrderDetailModel.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 订单详情model
*/
 
@class BATFamilyDoctorOrderInfoData;

@interface BATFamilyDoctorOrderInfoModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATFamilyDoctorOrderInfoData *Data;

@end

@interface BATFamilyDoctorOrderInfoData : NSObject

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *OrderExpireTime;

@property (nonatomic, assign) CGFloat OrderMoney;

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger OrderPayStatus;

@property (nonatomic, copy) NSString *OrderServerName;

@property (nonatomic, assign) NSInteger OrderServerTime;

@property (nonatomic, copy) NSString *OrderServiceTimeEnum;

@property (nonatomic, assign) NSInteger OrderStatus;

@property (nonatomic, assign) NSInteger OrderStatusShow;

@property (nonatomic, copy) NSString *PhoneNumber;

@property (nonatomic, copy) NSString *ServerTime;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic,assign) BOOL IsComment;

@property (nonatomic,assign) BOOL IsOrder;

@end

