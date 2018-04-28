//
//  MQOTCMessage.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "MQBaseMessage.h"

@interface MQOTCMessage : MQBaseMessage


/**
 预约id
 */
@property (nonatomic, copy) NSString *OPDRegisterID;

/**
 处方单url
 */
@property (nonatomic, copy) NSString *RecipeImgUrl;

/**
 处方ID
 */
@property (nonatomic, copy) NSString *RecipeFileID;

/**
 处方编号
 */
@property (nonatomic, copy) NSString *RecipeNo;

/**
 处方名称
 */
@property (nonatomic, copy) NSString *RecipeName;

/**
 处方类型名称
 */
@property (nonatomic, copy) NSString *RecipeTypeName;

/**
 处方类型
 */
@property (nonatomic, assign) NSInteger RecipeType;

/**
 金额
 */
@property (nonatomic, copy) NSString *Amount;

/**
 医生id
 */
@property (nonatomic, copy) NSString *DoctorID;

/**
 代煎费用单价 元/剂
 */
@property (nonatomic, copy) NSString *ReplacePrice;

/**
 判断是否代煎 0 否，非0是代煎
 */
@property (nonatomic, assign) NSInteger ReplaceDose;

/**
 一共多少剂
 */
@property (nonatomic, assign) NSInteger TCMQuantity;

/**
 * 用字典初始化message
 */
- (instancetype)initWithContent:(NSDictionary *)content;

@end
