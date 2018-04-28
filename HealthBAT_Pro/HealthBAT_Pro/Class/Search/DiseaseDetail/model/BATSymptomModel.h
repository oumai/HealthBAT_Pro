//
//  BATSymptomModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class symptomData,DiseaseListDetail,AboutSymptomListDetail;
@interface BATSymptomModel : NSObject

@property (nonatomic, strong) symptomData *Data;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) BOOL isNameOpen;

@property (nonatomic, assign) BOOL isCauseOpen;

@property (nonatomic, assign) BOOL RelateExaminIsOpen;

@property (nonatomic, assign) BOOL RelateTreatmentIsOpen;

@property (nonatomic, assign) BOOL RelateNurseIsOpen;


@end

@interface symptomData : NSObject

@property (nonatomic, copy) NSString *SORTNUMBER;

@property (nonatomic, strong) NSArray<DiseaseListDetail *> *AboutDiseaseList;

@property (nonatomic, copy) NSString *RELATED_SYMPTOM_NLIST;

@property (nonatomic, copy) NSString *IsDeleted;

@property (nonatomic, copy) NSString *CAUSE_DETAIL;

@property (nonatomic, copy) NSString *SHOULD_EAT_FOOD_LIST;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *SHOULD_EAT_FOOD_CONCLUSION;

@property (nonatomic, copy) NSString *LastModifiedTime;

@property (nonatomic, copy) NSString *MITIGATION_METHOD;

@property (nonatomic, copy) NSString *PREVENTION_DETAIL;

@property (nonatomic, copy) NSString *BRIEFINTRO_CONTENT;

@property (nonatomic, copy) NSString *CreatedBy;

@property (nonatomic, copy) NSString *SYMPTOM_NAME_EN;

@property (nonatomic, copy) NSString *LastModifiedBy;

@property (nonatomic, copy) NSString *SYMPTOM_NAME;

@property (nonatomic, copy) NSString *INSPECTION_DETAIL;

@property (nonatomic, copy) NSString *PINYINCODE;

@property (nonatomic, copy) NSString *AVOID_EAT_FOOD_LIST;

@property (nonatomic, copy) NSString *POSSIBLE_DISEASE_NLIST;

@property (nonatomic, copy) NSString *IDENTIFICATION_DETAIL;

@property (nonatomic, strong) NSArray<AboutSymptomListDetail *> *AboutSymptomList;

@property (nonatomic, copy) NSString *RELATED_INSPECTIONS_LIST;

@property (nonatomic, copy) NSString *RELATED_SYMPTOM_LIST;

@property (nonatomic, copy) NSString *RELATED_INSPECTIONS_NLIST;

@property (nonatomic, copy) NSString *POSSIBLE_DISEASE_LIST;

@property (nonatomic, copy) NSString *AVOID_EAT_FOOD_CONCLUSION;

@property (nonatomic, copy) NSString *PUBCAT_ID;

@property (nonatomic, copy) NSString *PART_ID;

@property (nonatomic, copy) NSString *PICTURE_URL;

@property (nonatomic, copy) NSString *GROUP_NAME;

@property(nonatomic,assign)BOOL isExaimBtnShow;

@property(nonatomic,assign)BOOL isTreatmentBtnShow;

@property(nonatomic,assign)BOOL isNurseBtnShow;

@end

@interface AboutSymptomListDetail : NSObject

@end

@interface DiseaseListDetail : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *Name;

@end
