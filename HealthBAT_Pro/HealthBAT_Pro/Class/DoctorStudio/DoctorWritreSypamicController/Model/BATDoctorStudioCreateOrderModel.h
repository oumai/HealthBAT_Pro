//
//  BATDoctorStudioCreateOrderModel.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/192017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

//@class CreateOrderData;
@interface BATDoctorStudioCreateOrderModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy) NSString *Data;

@end


//@interface CreateOrderData : NSObject
//
///**
// 信息
// */
//@property (nonatomic, copy) NSString *ResultMessage;
//
///**
// 状态值
// */
//@property (nonatomic, copy) NSString *ResultCode;
//
///**
// 订单号
// */
//@property (nonatomic, copy) NSString *Data;
//
//
//@end
