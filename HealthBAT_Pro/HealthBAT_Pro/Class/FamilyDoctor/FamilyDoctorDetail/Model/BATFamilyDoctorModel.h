//
//  BATFamilyDoctorModel.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

/*
 家庭医生详情model
 */

@class BATFamilyDoctorDetailData;
//@class BATFamilyDoctorServiceData;
@class BATFamilyDoctorServiceCostData;

@interface BATFamilyDoctorModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy  ) NSString *ResultMessage;

@property (nonatomic, strong  ) BATFamilyDoctorDetailData *Data;

@end



@interface BATFamilyDoctorDetailData : NSObject

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *DoctorPic;

@property (nonatomic, copy) NSString *DoctorTitle;

@property (nonatomic, copy) NSString *GoodAt;

@property (nonatomic, copy) NSString *DoctorDesc;

@property (nonatomic, copy) NSString *FamilyServiceJson;

@property (nonatomic, copy) NSString *FamilyService;

@property (nonatomic, copy) NSString *FamilyDoctorCostJson;

@property (nonatomic, copy) NSString *TrueName;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, copy) NSString *ContactAddress;

@property (nonatomic, copy) NSString *ThisTime;

@property (nonatomic, copy) NSString *FamilyServiceKey;

@property (nonatomic,copy) NSString *ConsultNum;

@property (nonatomic,copy) NSString *EvaluateRate;

//@property (nonatomic, copy  ) NSArray<BATFamilyDoctorServiceData   *> *ServiceData;

@property (nonatomic, copy  ) NSMutableArray<BATFamilyDoctorServiceCostData   *> *FamilyDoctorCost;

@end


//
//@interface BATFamilyDoctorServiceData : NSObject
//
//@property (nonatomic, copy) NSString *TKey;
//
//@property (nonatomic, copy) NSString *TValue;
//
//@end



@interface BATFamilyDoctorServiceCostData : NSObject

@property (nonatomic, copy) NSString *TKey;

@property (nonatomic, copy) NSString *TValue;

@end
