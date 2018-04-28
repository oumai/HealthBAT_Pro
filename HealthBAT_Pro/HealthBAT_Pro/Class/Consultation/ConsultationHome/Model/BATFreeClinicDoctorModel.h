//
//  BATFreeClinicDoctorModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FreeClinicDoctorData,FreeClinicDoctorclinic,FreeClinicDoctorUser,FreeClinicDoctorservices;
@interface BATFreeClinicDoctorModel : NSObject


@property (nonatomic, strong) NSArray<FreeClinicDoctorData *> *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;


@end
@interface FreeClinicDoctorData : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, assign) NSInteger IDType;

@property (nonatomic, copy) NSString *Duties;

@property (nonatomic, assign) NSInteger Marriage;

@property (nonatomic, assign) NSInteger Sort;

@property (nonatomic, copy) NSString *DepartmentID;

@property (nonatomic, copy) NSString *PostCode;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, assign) BOOL IsExpert;

@property (nonatomic, copy) NSString *Intro;

@property (nonatomic, assign) NSInteger CheckState;

@property (nonatomic, copy) NSString *DoctorName;

@property (nonatomic, strong) NSArray<FreeClinicDoctorservices *> *DoctorServices;

@property (nonatomic, assign) NSInteger ScheduleCount;

@property (nonatomic, assign) NSInteger Gender;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *Hospital;

@property (nonatomic, strong) FreeClinicDoctorUser *User;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *Grade;

@property (nonatomic, strong) FreeClinicDoctorclinic *DoctorClinic;

@property (nonatomic, copy) NSString *HospitalID;

@property (nonatomic, copy) NSString *Education;

@property (nonatomic, copy) NSString *SignatureURL;

@property (nonatomic, copy) NSString *areaCode;

@property (nonatomic, assign) BOOL IsConsultation;

@property (nonatomic, copy) NSString *Specialty;

@property (nonatomic, copy) NSString *Department;

@end

@interface FreeClinicDoctorclinic : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *ClinicMonth;

@property (nonatomic, copy) NSString *CreateUserID;

@property (nonatomic, assign) BOOL State;

@property (nonatomic, copy) NSString *DoctorClinicID;

@property (nonatomic, assign) NSInteger AcceptCount;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, copy) NSString *ModifyUserID;

@property (nonatomic, copy) NSString *ClinicDates;

@property (nonatomic, assign) NSInteger CurrentCount;

@property (nonatomic, copy) NSString *ServiceID;

@end

@interface FreeClinicDoctorUser : NSObject

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *PayPassword;

@property (nonatomic, copy) NSString *UserAccount;

@property (nonatomic, assign) NSInteger Checked;

@property (nonatomic, assign) NSInteger UserLevel;

@property (nonatomic, copy) NSString *PhotoUrl;

@property (nonatomic, copy) NSString *Password;

@property (nonatomic, assign) NSInteger Score;

@property (nonatomic, assign) NSInteger Good;

@property (nonatomic, assign) NSInteger Comment;

@property (nonatomic, copy) NSString *Answer;

@property (nonatomic, copy) NSString *RegTime;

@property (nonatomic, copy) NSString *UserCNName;

@property (nonatomic, copy) NSString *UserENName;

@property (nonatomic, copy) NSString *Mobile;

@property (nonatomic, copy) NSString *Question;

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, copy) NSString *Email;

@property (nonatomic, assign) NSInteger Star;

@property (nonatomic, assign) NSInteger Grade;

@property (nonatomic, assign) NSInteger Fans;

@property (nonatomic, copy) NSString *CancelTime;

@property (nonatomic, copy) NSString *LastTime;

@property (nonatomic, assign) NSInteger UserType;

@property (nonatomic, assign) NSInteger Terminal;

@property (nonatomic, assign) NSInteger UserState;

@end

@interface FreeClinicDoctorservices : NSObject

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, assign) NSInteger ServicePrice;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, assign) NSInteger ServiceSwitch;

@property (nonatomic, copy) NSString *ServiceID;

@end

