//
//  BATHospitalRegisterDoctorModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class HospitalRegisterDoctorData;
@interface BATHospitalRegisterDoctorModel : NSObject

@property (nonatomic, strong) HospitalRegisterDoctorData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface HospitalRegisterDoctorData : NSObject

@property (nonatomic, copy) NSString *UNIT_ID;

@property (nonatomic, copy) NSString *TITLENAME;

@property (nonatomic, copy) NSString *PAY_PASS_TIME;

@property (nonatomic, assign) NSInteger DOCTOR_ID;

@property (nonatomic, assign) BOOL SEX;

@property (nonatomic, copy) NSString *EXPERT;

@property (nonatomic, copy) NSString *ZCID;

@property (nonatomic, copy) NSString *TREAT_LIMIT;

@property (nonatomic, copy) NSString *IMAGE;

@property (nonatomic, copy) NSString *DOCTOR_NAME;

@property (nonatomic, assign) NSInteger TITLENO;

@property (nonatomic, copy) NSString *DETAIL;

@property (nonatomic, copy) NSString *UNIT_NAME;

@property (nonatomic, copy) NSString *DEP_NAME;

@property (nonatomic, copy) NSString *LEFT_NUM;

@property (nonatomic, copy) NSString *PAY_METHOD;

@property (nonatomic, assign) BOOL IsCollectLink;

@property (nonatomic, copy) NSString *DOC_SPELL;

@property (nonatomic, copy) NSString *DEP_ID;

@end

