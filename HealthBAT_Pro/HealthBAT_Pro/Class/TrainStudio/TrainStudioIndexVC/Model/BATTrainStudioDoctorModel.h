//
//  BATTrainStudioDoctorModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@class BATTrainStudioDoctorData;

@interface BATTrainStudioDoctorModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATTrainStudioDoctorData   *> *Data;

@end


@interface BATTrainStudioDoctorData : NSObject

@property (nonatomic, copy) NSString *AccountId;

@property (nonatomic, copy) NSString *DoctorTitle;

@property (nonatomic, copy) NSString *DoctorPic;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *GoodAt;

@end
