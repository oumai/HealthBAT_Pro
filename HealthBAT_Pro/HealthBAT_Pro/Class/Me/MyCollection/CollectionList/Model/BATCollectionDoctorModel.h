//
//  BATCollectionDoctorModel.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATCollectionDoctorData;
@interface BATCollectionDoctorModel : NSObject


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) NSArray<BATCollectionDoctorData *> *Data;


@end
@interface BATCollectionDoctorData : NSObject

@property (nonatomic, copy) NSString *HospitalGrade;

@property (nonatomic, copy) NSString *LastLoginTime;

@property (nonatomic, assign) BOOL IsCollectLink;

@property (nonatomic, assign) NSInteger CommentNum;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger VoiceConsultMoney;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, assign) NSInteger JobTile;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *QualificationCertificateImage;

@property (nonatomic, copy) NSString *AccountLevel;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, assign) NSInteger OnlineStatus;

@property (nonatomic, assign) BOOL IsFollowed;

@property (nonatomic, assign) NSInteger ConsultNum;

@property (nonatomic, copy) NSString *NativeCity;

@property (nonatomic, assign) NSInteger PrimaryInterestID;

@property (nonatomic, copy) NSString *City;

@property (nonatomic, assign) NSInteger FreeConsultNum;

@property (nonatomic, assign) NSInteger Age;

@property (nonatomic, assign) NSInteger TodayWordConsultNum;

@property (nonatomic, copy) NSString *PersonalInsuranceLevelText;

@property (nonatomic, copy) NSString *Skilled;

@property (nonatomic, copy) NSString *AccountName;

@property (nonatomic, copy) NSString *PhoneNumber;

@property (nonatomic, assign) NSInteger YuYueNum;

@property (nonatomic, copy) NSString *SexStr;

@property (nonatomic, assign) NSInteger CollectType;

@property (nonatomic, copy) NSString *JobTileImage;

@property (nonatomic, assign) BOOL IsMaster;

@property (nonatomic, copy) NSString *CountryText;

@property (nonatomic, assign) NSInteger VoiceConsultRecordID;

@property (nonatomic, copy) NSString *SexText;

@property (nonatomic, copy) NSString *NativeProvince;

@property (nonatomic, assign) NSInteger CityID;

@property (nonatomic, copy) NSString *jobTileName;

@property (nonatomic, assign) NSInteger EducationLevelCode;

@property (nonatomic, assign) NSInteger FansCount;

@property (nonatomic, assign) NSInteger WordConsultMoney;

@property (nonatomic, assign) NSInteger SourceNum;

@property (nonatomic, assign) NSInteger WordSourceNum;

@property (nonatomic, assign) NSInteger TodayVoiceConsultNum;

@property (nonatomic, assign) NSInteger VoiceConsultNum;

@property (nonatomic, assign) NSInteger Score;

@property (nonatomic, copy) NSString *Province;

@property (nonatomic, assign) NSInteger FollowNum;

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *Introduction;

@property (nonatomic, copy) NSString *Ethnicity;

@property (nonatomic, copy) NSString *PracticeLicenseImage;

@property (nonatomic, assign) NSInteger Sex;

@property (nonatomic, copy) NSString *PersonalInsuranceLevel;

@property (nonatomic, assign) NSInteger FreeConsultRecordID;

@property (nonatomic, assign) NSInteger DepartmentID;

@property (nonatomic, copy) NSString *DepartmentTel;

@property (nonatomic, assign) NSInteger Height;

@property (nonatomic, assign) NSInteger WordConsultNum;

@property (nonatomic, assign) NSInteger VoiceSourceNum;

@property (nonatomic, copy) NSString *IDCardImage;

@property (nonatomic, assign) NSInteger DoctorDetailID;

@property (nonatomic, copy) NSString *HospitalName;

@property (nonatomic, copy) NSString *DepartmentName;

@property (nonatomic, assign) NSInteger WordConsultRecordID;

@property (nonatomic, strong) NSArray *InterestIDs;

@property (nonatomic, assign) NSInteger BrowseCount;

@property (nonatomic, copy) NSString *DoctorAdeptSymptoms;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *EducationLevelText;

@property (nonatomic, assign) NSInteger HospitalID;

@property (nonatomic, assign) NSInteger CountryCode;

@property (nonatomic, copy) NSString *WorkingCardImage;

@end

