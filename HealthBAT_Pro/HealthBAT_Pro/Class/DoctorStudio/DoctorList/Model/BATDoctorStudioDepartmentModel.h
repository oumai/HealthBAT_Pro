//
//  BATDoctorStudioDepartmentModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDoctorStudioDepartmentData;
@interface BATDoctorStudioDepartmentModel : NSObject

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSMutableArray <BATDoctorStudioDepartmentData *> *Data;

@end

@interface BATDoctorStudioDepartmentData : NSObject

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *DepartmentName;

@end
