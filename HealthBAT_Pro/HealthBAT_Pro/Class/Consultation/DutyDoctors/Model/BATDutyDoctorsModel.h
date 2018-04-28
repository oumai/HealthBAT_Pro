//
//  BATDutyDoctorsModel.h
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATDutyDoctorsDataModel,BATDutyDoctorsDataUserModel;

@interface BATDutyDoctorsModel : NSObject

@property (nonatomic, strong) NSArray<BATDutyDoctorsDataModel *> *Data;

@property (nonatomic, assign) NSInteger Result;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, assign) NSInteger Total;

@property (nonatomic, copy) NSString *Msg;

@end

@interface BATDutyDoctorsDataModel : NSObject

@property (nonatomic, copy) NSString *DepartmentID;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString * DoctorID;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, copy) NSString * PhotoFullUrl;

@property (nonatomic, copy) NSString *Specialty;

@property (nonatomic, copy) NSString *TitleName;

@property (nonatomic, strong) BATDutyDoctorsDataUserModel *User;

@end

@interface BATDutyDoctorsDataUserModel : NSObject

@property (nonatomic, copy) NSString *PhotoUrl;

@end
