//
//  BATConsultationDoctorDetailModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class ConsultationDoctorDetailData;
//@interface BATConsultationDoctorDetailModel : NSObject
//
//@property (nonatomic, assign) NSInteger PagesCount;
//
//@property (nonatomic, assign) NSInteger ResultCode;
//
//@property (nonatomic, assign) NSInteger RecordsCount;
//
//@property (nonatomic, copy) NSString *ResultMessage;
//
//@property (nonatomic, strong) ConsultationDoctorDetailData *Data;
//
//@end
//@interface ConsultationDoctorDetailData : NSObject
//
//@property (nonatomic, copy) NSString *HospitalGrade;
//
//@property (nonatomic, copy) NSString *LastLoginTime;
//
//@property (nonatomic, assign) BOOL IsCollectLink;
//
//@property (nonatomic, assign) NSInteger CommentNum;
//
//@property (nonatomic, assign) NSInteger ID;
//
//@property (nonatomic, assign) CGFloat VoiceConsultMoney;
//
//@property (nonatomic, copy) NSString *CreatedTime;
//
//@property (nonatomic, assign) NSInteger JobTile;
//
//@property (nonatomic, copy) NSString *Birthday;
//
//@property (nonatomic, copy) NSString *QualificationCertificateImage;
//
//@property (nonatomic, copy) NSString *AccountLevel;
//
//@property (nonatomic, copy) NSString *UserName;
//
//@property (nonatomic, assign) NSInteger OnlineStatus;
//
//@property (nonatomic, assign) BOOL IsFollowed;
//
//@property (nonatomic, assign) NSInteger ConsultNum;
//
//@property (nonatomic, copy) NSString *NativeCity;
//
//@property (nonatomic, assign) NSInteger PrimaryInterestID;
//
//@property (nonatomic, copy) NSString *City;
//
//@property (nonatomic, assign) NSInteger FreeConsultNum;
//
//@property (nonatomic, assign) NSInteger Age;
//
//@property (nonatomic, assign) NSInteger TodayWordConsultNum;
//
//@property (nonatomic, copy) NSString *PersonalInsuranceLevelText;
//
//@property (nonatomic, copy) NSString *Skilled;
//
//@property (nonatomic, copy) NSString *AccountName;
//
//@property (nonatomic, copy) NSString *PhoneNumber;
//
//@property (nonatomic, assign) NSInteger YuYueNum;
//
//@property (nonatomic, copy) NSString *SexStr;
//
//@property (nonatomic, assign) NSInteger CollectType;
//
//@property (nonatomic, copy) NSString *JobTileImage;
//
//@property (nonatomic, assign) BOOL IsMaster;
//
//@property (nonatomic, copy) NSString *CountryText;
//
//@property (nonatomic, assign) NSInteger VoiceConsultRecordID;
//
//@property (nonatomic, copy) NSString *SexText;
//
//@property (nonatomic, copy) NSString *NativeProvince;
//
//@property (nonatomic, assign) NSInteger CityID;
//
//@property (nonatomic, copy) NSString *jobTileName;
//
//@property (nonatomic, copy) NSString *EducationLevelCode;
//
//@property (nonatomic, assign) NSInteger FansCount;
//
//@property (nonatomic, assign) CGFloat WordConsultMoney;
//
//@property (nonatomic, assign) NSInteger SourceNum;
//
//@property (nonatomic, assign) NSInteger WordSourceNum;
//
//@property (nonatomic, assign) NSInteger TodayVoiceConsultNum;
//
//@property (nonatomic, assign) NSInteger VoiceConsultNum;
//
//@property (nonatomic, assign) NSInteger Score;
//
//@property (nonatomic, copy) NSString *Province;
//
//@property (nonatomic, assign) NSInteger FollowNum;
//
//@property (nonatomic, assign) NSInteger AccountID;
//
//@property (nonatomic, copy) NSString *Introduction;
//
//@property (nonatomic, copy) NSString *Ethnicity;
//
//@property (nonatomic, copy) NSString *PracticeLicenseImage;
//
//@property (nonatomic, assign) NSInteger Sex;
//
//@property (nonatomic, copy) NSString *PersonalInsuranceLevel;
//
//@property (nonatomic, assign) NSInteger FreeConsultRecordID;
//
//@property (nonatomic, assign) NSInteger DepartmentID;
//
//@property (nonatomic, copy) NSString *DepartmentTel;
//
//@property (nonatomic, copy) NSString *Height;
//
//@property (nonatomic, assign) NSInteger WordConsultNum;
//
//@property (nonatomic, assign) NSInteger VoiceSourceNum;
//
//@property (nonatomic, copy) NSString *IDCardImage;
//
//@property (nonatomic, assign) NSInteger DoctorDetailID;
//
//@property (nonatomic, copy) NSString *HospitalName;
//
//@property (nonatomic, copy) NSString *DepartmentName;
//
//@property (nonatomic, assign) NSInteger WordConsultRecordID;
//
//@property (nonatomic, copy) NSString *InterestIDs;
//
//@property (nonatomic, copy) NSString *BrowseCount;
//
//@property (nonatomic, strong) NSArray *DoctorAdeptSymptoms;
//
//@property (nonatomic, copy) NSString *PhotoPath;
//
//@property (nonatomic, copy) NSString *EducationLevelText;
//
//@property (nonatomic, assign) NSInteger HospitalID;
//
//@property (nonatomic, assign) NSInteger CountryCode;
//
//@property (nonatomic, copy) NSString *WorkingCardImage;
//
//@end


@class ConsultationDoctorDetailData,ConsultationDoctorDetailUser,ConsultationDoctorDetailDoctorservices;
@interface BATConsultationDoctorDetailModel : NSObject


@property (nonatomic, strong) ConsultationDoctorDetailData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;


@end
@interface ConsultationDoctorDetailData : NSObject

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

@property (nonatomic, strong) NSArray<ConsultationDoctorDetailDoctorservices *> *DoctorServices;

@property (nonatomic, assign) NSInteger Gender;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *Hospital;

@property (nonatomic, strong) ConsultationDoctorDetailUser *User;

@property (nonatomic, copy) NSString *DoctorClinic;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, copy) NSString *Grade;

@property (nonatomic, copy) NSString *HospitalID;

@property (nonatomic, copy) NSString *Education;

@property (nonatomic, copy) NSString *SignatureURL;

@property (nonatomic, copy) NSString *areaCode;

@property (nonatomic, assign) BOOL IsConsultation;

@property (nonatomic, assign) BOOL IsFreeClinicr;

@property (nonatomic, copy) NSString *Specialty;

@property (nonatomic, copy) NSString *Department;

@property (nonatomic, assign) NSInteger ScheduleCount;

@end

@interface ConsultationDoctorDetailUser : NSObject

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

@interface ConsultationDoctorDetailDoctorservices : NSObject

@property (nonatomic, assign) NSInteger ServiceType;

@property (nonatomic, assign) double ServicePrice;

@property (nonatomic, copy) NSString *DoctorID;

@property (nonatomic, assign) BOOL ServiceSwitch;

@property (nonatomic, copy) NSString *ServiceID;

@end

