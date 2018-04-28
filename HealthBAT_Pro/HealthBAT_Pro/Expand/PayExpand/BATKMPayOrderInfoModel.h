//
//  BATKMPayOrderInfoModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/5/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATKMPayData;
@interface BATKMPayOrderInfoModel : NSObject

@property (nonatomic, strong) BATKMPayData *Data;

@end
@interface BATKMPayData : NSObject

@property (nonatomic, copy) NSString *partner;

@property (nonatomic, copy) NSString *notifyUrl;

@property (nonatomic, copy) NSString *returnUrl;

@property (nonatomic, copy) NSString *outTradeNo;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *sellerEmail;

@property (nonatomic, copy) NSString *subject;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *sign;

@end
