//
//  BATHealthTestRecordModel.h
//  HealthBAT
//
//  Created by KM on 16/6/162016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATHealthTestRecordData;
@interface BATHealthTestRecordModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATHealthTestRecordData *> *Data;

@end
@interface BATHealthTestRecordData : NSObject

@property (nonatomic, assign) NSInteger ScoreResult;

@property (nonatomic, copy) NSString *IsSubhealthy;

@property (nonatomic, assign) NSInteger AccountId;

@property (nonatomic, assign) BOOL IsDeleted;

@property (nonatomic, copy) NSString *HealthAssessment;

@property (nonatomic, assign) NSInteger EvaluationTempId;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *ResultDesc;

@property (nonatomic, copy) NSString *Theme;

@end

