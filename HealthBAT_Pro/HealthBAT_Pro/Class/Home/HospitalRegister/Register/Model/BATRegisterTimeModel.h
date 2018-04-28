//
//  RegisterTimeModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATRegisterTimeData;
@interface BATRegisterTimeModel : NSObject

@property (nonatomic, assign) NSInteger           PagesCount;

@property (nonatomic, assign) NSInteger           ResultCode;

@property (nonatomic, assign) NSInteger           RecordsCount;

@property (nonatomic, copy  ) NSString            *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATRegisterTimeData *> *Data;

@end
@interface BATRegisterTimeData : NSObject

@property (nonatomic, copy  ) NSString            *SCHEDULE_ID;

@property (nonatomic, copy  ) NSString            *BEGIN_TIME;

@property (nonatomic, assign) NSInteger           LEFT_NUM;

@property (nonatomic, copy  ) NSString            *DETL_ID;

@property (nonatomic, copy  ) NSString            *END_TIME;

@end

