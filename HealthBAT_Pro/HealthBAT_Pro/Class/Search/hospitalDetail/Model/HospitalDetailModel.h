//
//  HospitalDetailModel.h
//  HealthBAT
//
//  Created by shipeiyuan on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HospitalDetailData;

@interface HospitalDetailModel : NSObject

@property (nonatomic, assign)   NSInteger PagesCount;

@property (nonatomic, assign)   NSInteger ResultCode;

@property (nonatomic, assign)   NSInteger RecordsCount;

@property (nonatomic, copy)     NSString *ResultMessage;

@property (nonatomic, strong)   HospitalDetailData *Data;
@end


@interface HospitalDetailData : NSObject
@property (nonatomic, copy) NSString *IMAGE;

@property (nonatomic, copy) NSString *UNIT_LEVEL;

@property (nonatomic, copy) NSString *PAY_METHODS;

@property (nonatomic, copy) NSString *PAYMENT;

@property (nonatomic, copy) NSString *MAPS;

@property (nonatomic, assign) BOOL  IsCollectLink;

@property (nonatomic, copy) NSString *AREA_ID;

@property (nonatomic, strong) NSArray *DepartmentList;

@property (nonatomic, copy) NSString *UNIT_NAME;

@property (nonatomic, copy) NSString *URL;

@property (nonatomic, copy) NSString *LEFT_NUM;

@property (nonatomic, copy) NSString *DETAIL;

@property (nonatomic, copy) NSString *CITY_ID;

@property (nonatomic, copy) NSString *UNIT_CLASS;

@property (nonatomic, copy) NSString *ADDRESS;

@property (nonatomic, copy) NSString *PHONE;

@property (nonatomic, copy) NSString *UNIT_SPELL;

@property (nonatomic, copy) NSString *UNIT_ALIAS;

@property (nonatomic, copy) NSString *UNIT_ID;

@property (nonatomic, assign) NSInteger HOSPITAL_LEVEL;

@end
