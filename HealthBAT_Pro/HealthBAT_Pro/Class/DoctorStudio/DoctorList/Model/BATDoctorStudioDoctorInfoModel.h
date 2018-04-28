//
//  BATDoctorStudioDoctorInfoModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDoctorStudioDoctorInfoData;
@interface BATDoctorStudioDoctorInfoModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATDoctorStudioDoctorInfoData *> *Data;

@end

@interface BATDoctorStudioDoctorInfoData : NSObject

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *DepartmentName;

@property (nonatomic,copy) NSString *DoctorName;

@property (nonatomic,copy) NSString *DoctorPic;

@property (nonatomic,copy) NSString *DoctorTitle;

@property (nonatomic,copy) NSString *HospitalName;

@property (nonatomic,copy) NSString *GoodAt;

@property (nonatomic,copy) NSString *Price;

@property (nonatomic,copy) NSString *BuyNum;

@end
