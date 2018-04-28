//
//  HospitalModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/142016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATHospitalData;


@interface BATHospitalModel : NSObject

@property (nonatomic, assign) NSInteger       PagesCount;

@property (nonatomic, assign) NSInteger       ResultCode;

@property (nonatomic, assign) NSInteger       RecordsCount;

@property (nonatomic, copy  ) NSString        *ResultMessage;

@property (nonatomic, copy  ) NSArray<BATHospitalData *> *Data;

@end


@interface BATHospitalData : NSObject

@property (nonatomic, copy  ) NSString        *UNIT_LEVEL;

@property (nonatomic, assign) NSInteger       PAY_METHODS;

@property (nonatomic, copy  ) NSString        *DepartmentList;

@property (nonatomic, assign) NSInteger       PAYMENT;

@property (nonatomic, copy  ) NSString        *IMAGE;

@property (nonatomic, copy  ) NSString        *kMAP;

@property (nonatomic, assign) BOOL            IsCollectLink;

@property (nonatomic, assign) NSInteger       AREA_ID;

@property (nonatomic, copy  ) NSString        *UNIT_NAME;

@property (nonatomic, copy  ) NSString        *URL;

@property (nonatomic, assign) NSInteger       LEFT_NUM;

@property (nonatomic, copy  ) NSString        *DETAIL;

@property (nonatomic, assign) NSInteger       CITY_ID;

@property (nonatomic, copy  ) NSString        *UNIT_CLASS;

@property (nonatomic, copy  ) NSString        *ADDRESS;

@property (nonatomic, copy  ) NSString        *PHONE;

@property (nonatomic, copy  ) NSString        *UNIT_SPELL;

@property (nonatomic, copy  ) NSString        *UNIT_ALIAS;

@property (nonatomic, assign) NSInteger       UNIT_ID;

@end

