//
//  BATNotificationMessage.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/172017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface BATNotificationMessage : RCMessageContent

/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/**
 * 图文服务状态
 */
@property(nonatomic, copy) NSString *actionStatus;

/**
 订单号
 */
@property(nonatomic, copy) NSString *orderNo;

/**
 融云目标id
 */
@property(nonatomic, copy) NSString *targetId;

/**
 医生名字
 */
@property(nonatomic, copy) NSString *doctorName;


/**
 患者名字
 */
@property(nonatomic, copy) NSString *patientName;


/**
 创建通知的自定义消息
 
 @param actionStatus 请求状态
 @param orderNo 订单号
 @param targetId 融云targetId
 @param doctorName 医生名字
 @param patientName 患者名字
 @return 消息实例
 */
+ (instancetype)messageWithActionStatus:(NSString *)actionStatus
                                orderNo:(NSString *)orderNo
                               targetId:(NSString *)targetId
                             doctorName:(NSString *)doctorName
                            patientName:(NSString *)patientName;


@end
