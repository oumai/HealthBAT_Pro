//
//  BATHealthThreeSecondsModel.h
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATHealthThreeSecondsModel : NSObject
/*
 "AccountID": 2842,
 "DataDate": "2017-12-08 00:00:00",
 "CaloriesIntake": "557.80",
 "DrinkingWater": 0,
 "WalkingDistance": "3.20",
 "CaloriesConsume": "0.00",
 "WalkSteps": 0,
 "SleepHours": "0.00",
 "BedTime": "0001-01-01 00:00:00",
 "GetUpTime": "0001-01-01 00:00:00",
 "Mood": 2,
 "LastModifiedTime": "2017-12-08 12:57:33"
 */
/**
 数据日期
 */
@property(nonatomic, strong)NSString *AccountID;
/**
 数据日期
 */
@property(nonatomic, strong)NSString *DataDate;
/**
 摄入总卡路里数
 */
@property(nonatomic, strong)NSString *CaloriesIntake;
/**
 每日喝水总杯数
 */
@property(nonatomic, assign)NSInteger DrinkingWater;
/**
 行走距离(单位:公里)
 */
@property(nonatomic, strong)NSString *WalkingDistance;
/**
 消耗的总卡路里数
 */
@property(nonatomic, strong)NSString *CaloriesConsume;
/**
 步数
 */
@property(nonatomic, strong)NSString *WalkSteps;
/**
 睡眠时间
 */
@property(nonatomic, strong)NSString *SleepHours;
/**
 就寝时间
 */
@property(nonatomic, strong)NSString *BedTime;
/**
 起床时间
 */
@property(nonatomic, strong)NSString *GetUpTime;
/**
 心情,2很好,1好,0一般,-1不好,-2很糟糕
 */
@property(nonatomic, assign)NSInteger Mood;
/**
 数据日期
 */
@property(nonatomic, strong)NSString *LastModifiedTime;
@end
