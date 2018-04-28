//
//  DutyModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATDutyData;
@interface BATDutyModel : NSObject

@property (nonatomic, assign) NSInteger   PagesCount;

@property (nonatomic, assign) NSInteger   ResultCode;

@property (nonatomic, assign) NSInteger   RecordsCount;

@property (nonatomic, copy  ) NSString    *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATDutyData *> *Data;

@end
@interface BATDutyData : NSObject

@property (nonatomic, assign) NSInteger   DEP_ID;

@property (nonatomic, copy  ) NSString    *TIME_TYPE_DESC;

@property (nonatomic, copy  ) NSString    *TO_DATE;

@property (nonatomic, assign) NSInteger   DOCTOR_ID;

@property (nonatomic, copy  ) NSString    *END_TIME;

@property (nonatomic, assign) NSInteger   LEFT_NUM;

@property (nonatomic, copy  ) NSString    *DOCTOR_NAME;

@property (nonatomic, assign) NSInteger   GUAHAO_AMT;

@property (nonatomic, assign) NSInteger   YUYUE_MAX;

@property (nonatomic, copy  ) NSString    *TIME_TYPE;

@property (nonatomic, copy  ) NSString    *SCHEDULE_ID;

@property (nonatomic, copy  ) NSString    *BEGIN_TIME;

@property (nonatomic, copy  ) NSString    *LEVEL_NAME;

@property (nonatomic, assign) NSInteger   UNIT_ID;

@end

