//
//  BATDoctorStatusModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDoctorStatusData;
@interface BATDoctorStatusModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATDoctorStatusData *Data;

@end


@interface BATDoctorStatusData : NSObject

//医生工作室
@property (nonatomic,assign) BOOL IsOpenRoom;
//0待审核/审核中 1审核通过  2审核不通过 3 关闭工作室
@property (nonatomic,assign) NSInteger Auditing;

@property (nonatomic,copy) NSString *AuditingContent;

@property (nonatomic,copy) NSString *DoctorID;


//培训工作室参数
@property (nonatomic,assign) BOOL IsOpenTrainRoom;
// 0待审核/审核中 1审核通过  2审核不通过 3 关闭工作室
@property (nonatomic,assign) NSInteger TrainAuditing;

@property (nonatomic,copy) NSString *TrainAuditingContent;

@property (nonatomic,copy) NSString *TrainID;

@end
