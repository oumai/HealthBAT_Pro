//
//  BATUpdateHealthInfoModel.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATUpdateHealthData;
@interface BATUpdateHealthInfoModel : NSObject
@property (nonatomic, copy) NSString *ResultMessage; //提示信息
@property (nonatomic, assign) NSInteger ResultCode; //返回码，0 代表无错误 -1代表有错误
@property (nonatomic, strong) BATUpdateHealthData *Data;
@end

@interface BATUpdateHealthData : NSObject
@property (nonatomic, assign) NSInteger AccountID; // 用户ID
@property (nonatomic, copy) NSString *DataDate; // 数据日期
@property (nonatomic, copy) NSString *CaloriesIntake; // 当天摄入的总卡路里数
@property (nonatomic, assign) NSInteger DrinkingWater; // 当天喝水总杯数
@property (nonatomic, copy) NSString *WalkingDistance;  //行走距离
@property (nonatomic, copy) NSString *CaloriesConsume; //当天消耗的总卡路里数
@property (nonatomic, assign) NSInteger WalkSteps; //步数
@property (nonatomic, copy) NSString *SleepHours; //睡眠小时数
@property (nonatomic, copy) NSString *BedTime; //就寝时间
@property (nonatomic, copy) NSString *GetUpTime; //起床时间
@property (nonatomic, assign) NSInteger Mood;  //心情状态,2非常好,1好,0一般,-1不好,-2很糟糕
@property (nonatomic, copy) NSString *LastModifiedTime; //更新时间


@end
