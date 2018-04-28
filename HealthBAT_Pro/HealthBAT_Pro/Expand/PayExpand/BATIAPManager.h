//
//  BATIAPManager.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/11.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATIAPManager : NSObject

+ (BATIAPManager *)shareManager;

/**
 设置支付服务监听
 */
- (void)addTransactionObserver;

/**
 移除支付服务监听
 */
- (void)removeTransactionObserver;

/**
 开始支付

 @param productIdentifier 产品id
 @param orderNo 订单号
 */
- (void)pay:(NSString *)productIdentifier orderNo:(NSString *)orderNo;

/**
 验证遗漏的票据
 */
- (void)checkUnchekReceipt;

@end
