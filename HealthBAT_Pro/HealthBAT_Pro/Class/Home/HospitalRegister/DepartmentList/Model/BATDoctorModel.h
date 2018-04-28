//
//  DoctorModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDoctorData;


@interface BATDoctorModel : NSObject

@property (nonatomic, assign) NSInteger     PagesCount;

@property (nonatomic, assign) NSInteger     ResultCode;

@property (nonatomic, assign) NSInteger     RecordsCount;

@property (nonatomic, copy  ) NSString      *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATDoctorData *> *Data;

@end


@interface BATDoctorData : NSObject

@property (nonatomic, copy  ) NSString      *UNIT_ID;

@property (nonatomic, copy  ) NSString      *PAY_PASS_TIME;

@property (nonatomic, assign) NSInteger     DOCTOR_ID;

@property (nonatomic, assign) BOOL          SEX;

@property (nonatomic, copy  ) NSString      *EXPERT;

@property (nonatomic, copy  ) NSString      *ZCID;

@property (nonatomic, copy  ) NSString      *TREAT_LIMIT;

@property (nonatomic, copy  ) NSString      *IMAGE;

@property (nonatomic, copy  ) NSString      *DOCTOR_NAME;

@property (nonatomic, copy  ) NSString      *DETAIL;

@property (nonatomic, copy  ) NSString      *UNIT_NAME;

@property (nonatomic, copy  ) NSString      *LEFT_NUM;

@property (nonatomic, copy  ) NSString      *DEP_NAME;

@property (nonatomic, copy  ) NSString      *PAY_METHOD;

@property (nonatomic, copy  ) NSString      *DOC_SPELL;

@property (nonatomic, copy  ) NSString      *DEP_ID;

@end

