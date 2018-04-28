//
//  BATFamilyDoctorOrderDetailModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/*
 订单请求信息model
 */

@class BATFamilyDoctorOrderDetailData;

@interface BATFamilyDoctorOrderDetailModel : NSObject
@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong  ) BATFamilyDoctorOrderDetailData *Data;

@end


@interface BATFamilyDoctorOrderDetailData : NSObject

@property (nonatomic, copy) NSString *OrderNo;

@property (nonatomic, copy) NSString *TrueName;

@property (nonatomic, copy) NSString *PhoneNumber;

@property (nonatomic, copy) NSString *FamilyService;

@property (nonatomic, copy) NSString *OrderServerTime;

@property (nonatomic, assign)CGFloat OrderMoney;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *ServerTime;

@end
