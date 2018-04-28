//
//  BATNearFamilyDoctorModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

/*
 家庭医生model
 */

@class BATNearFamilyDoctorData;

@interface BATNearFamilyDoctorModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATNearFamilyDoctorData   *> *Data;

@end


@interface BATNearFamilyDoctorData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *DoctorPic;

@property (nonatomic, copy) NSString *HospitalName;

@end
