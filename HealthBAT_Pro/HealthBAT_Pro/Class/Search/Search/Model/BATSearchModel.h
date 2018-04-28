//
//  SearchModel.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class SearchData,Resultentity,Treatmentresult,Doctorresult,DoctorList,Informationresult,Informationlist,Hospitalresult,HospitalList,Conditionresult,ConditionList,TreatmentList;
@interface BATSearchModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) SearchData *Data;

@end
@interface SearchData : NSObject

@property (nonatomic, strong) Resultentity *ResultEntity;

@property (nonatomic, assign) CGFloat CostTime;

@property (nonatomic, copy) NSString *SearchKeyword;

@property (nonatomic, assign) NSInteger ResultCount;

@end

@interface Resultentity : NSObject

@property (nonatomic, strong) Treatmentresult *TreatmentResult;

@property (nonatomic, strong) Doctorresult *DoctorResult;

@property (nonatomic, strong) Informationresult *InformationResult;

@property (nonatomic, strong) Hospitalresult *HospitalResult;

@property (nonatomic, strong) Conditionresult *ConditionResult;

@end

@interface Treatmentresult : NSObject

@property (nonatomic, assign) NSInteger TreatmentCount;

@property (nonatomic, strong) NSArray<TreatmentList *> *TreatmentList;

@end

@interface TreatmentList : NSObject

@property (nonatomic, assign) NSInteger EntityID;

@property (nonatomic, copy) NSString *EntryCNName;

@property (nonatomic, copy) NSString *EntryDescription;

@property (nonatomic, copy) NSString *EntryImgUrl;

@property (nonatomic, copy) NSString *EntryInstructions;

@property (nonatomic, copy) NSString *EntryPrecautions;

@property (nonatomic, copy) NSString *EntrySideEffects;

@property (nonatomic, copy) NSString *EntryType;

@property (nonatomic, copy) NSString *manufactorName;

@end

@interface Doctorresult : NSObject

@property (nonatomic, assign) NSInteger DoctorCount;

@property (nonatomic, strong) NSArray<DoctorList *> *DoctorList;

@end

@interface DoctorList : NSObject

@property (nonatomic, assign) NSInteger EntityID;

@property (nonatomic, copy) NSString *EntryType;

@property (nonatomic, copy) NSString *EntryCNName;

@property (nonatomic, copy) NSString *EntryImgUrl;

@property (nonatomic, copy) NSString *EntryDepartmentName;

@property (nonatomic, copy) NSString *Skilful;

@property (nonatomic, copy) NSString *JobTileName;

@property (nonatomic, assign) NSInteger JobTile;

@property (nonatomic, copy) NSString *EntryDescription;

@property (nonatomic, assign) NSInteger EntryHospitalID;

@end

@interface Informationresult : NSObject

@property (nonatomic, assign) NSInteger InformationCount;

@property (nonatomic, strong) NSArray<Informationlist *> *InformationList;

@end

@interface Informationlist : NSObject

@property (nonatomic, copy) NSString *EntryCNName;

@property (nonatomic, assign) NSInteger EntityID;

@property (nonatomic, assign) NSInteger EntryCategoryID;

@property (nonatomic, copy) NSString *EntryDescription;

@property (nonatomic, copy) NSString *EntryImgUrl;

@property (nonatomic, copy) NSString *EntryType;

@end

@interface Hospitalresult : NSObject

@property (nonatomic, assign) NSInteger HospitalCount;

@property (nonatomic, strong) NSArray<HospitalList *> *HospitalList;

@end

@interface HospitalList : NSObject

@property (nonatomic, assign) NSInteger EntityID;

@property (nonatomic, copy) NSString *EntryCNName;

@property (nonatomic, copy) NSString *EntryPhone;

@property (nonatomic, copy) NSString *EntryGrade;

@property (nonatomic, copy) NSString *EntryAddress;

@property (nonatomic, copy) NSString *EntryType;

@property (nonatomic, copy) NSString *EntryProperty;

@property (nonatomic, copy) NSString *EntryDescription;

@property (nonatomic, copy) NSString *EntryImgUrl;

@end

@interface Conditionresult : NSObject

@property (nonatomic, assign) NSInteger ConditionCount;

@property (nonatomic, strong) NSArray<ConditionList *> *ConditionList;

@end

@interface ConditionList : NSObject

@property (nonatomic, assign) NSInteger EntityID;

@property (nonatomic, copy) NSString *EntryCNName;

@property (nonatomic, copy) NSString *EntryDescription;

@property (nonatomic, copy) NSString *EntryType;

@end

