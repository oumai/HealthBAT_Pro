//
//  BATDoctorOfficeModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorOfficeDetail,DoctorService;
@interface BATDoctorOfficeModel : NSObject

@property (nonatomic,strong) NSString *ResultMessage;

@property (nonatomic,assign) NSInteger ResultCode;

@property (nonatomic,strong) DoctorOfficeDetail  *Data;
@end

@interface DoctorOfficeDetail : NSObject

@property (nonatomic,strong) NSString *DepartmentName;

@property (nonatomic,strong) NSString *DoctorName;

@property (nonatomic,strong) NSString *ConsultNum;

@property (nonatomic,strong) NSString *GoodAt;

@property (nonatomic,strong) NSString *DoctorTitle;

@property (nonatomic,strong) NSString *DoctorPic;

@property (nonatomic,strong) NSString *HospitalName;

@property (nonatomic,strong) NSString *ResultMessage;

@property (nonatomic,strong) NSString *DoctorDesc;

@property (nonatomic,strong) DoctorService *DoctorService;

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *EvaluateRate;

@end

@interface DoctorService : NSObject

@property (nonatomic,strong) NSString *VideoConsultCost;

@property(nonatomic,assign) BOOL IsVideoConsult;

@property (nonatomic,strong) NSString *VoiceConsultCost;

@property(nonatomic,assign) BOOL IsVoiceConsult;

@property (nonatomic,strong) NSString *WordConsultCost;

@property(nonatomic,assign) BOOL IsWordConsult;

@end
