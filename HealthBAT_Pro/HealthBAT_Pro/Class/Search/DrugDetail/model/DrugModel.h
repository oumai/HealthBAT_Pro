//
//  DrugModel.h
//  HealthBAT
//
//  Created by four on 16/8/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DurgData;
@class DiseaseList;
@interface DrugModel : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) DurgData *Data;

@end
@interface DurgData : NSObject

@property (nonatomic, copy) NSString *LASTMODIFIEDBY;

@property (nonatomic, strong) NSString *INDICATIONS;

@property (nonatomic, copy) NSString *DRUG_ALIAS;

@property (nonatomic, assign) BOOL IS_MEDINSURANCE;

@property (nonatomic, copy) NSString *DRUG_NAME;

@property (nonatomic, copy) NSString *DRUG_NAME_EN;

@property (nonatomic, copy) NSString *SIDEEFFECTS;

@property (nonatomic, copy) NSString *MANUFACTOR_NAME;

@property (nonatomic, copy) NSString *APPROVAL_NUMBER;

@property (nonatomic, assign) NSInteger CAT_ID;

@property (nonatomic, assign) BOOL IS_OTC;

@property (nonatomic, copy) NSString *PINYINCODE;

@property (nonatomic, copy) NSString *UNSUITABLE_PEOPLE;

@property (nonatomic, assign) BOOL ISDELETED;

@property (nonatomic, copy) NSString *LASTMODIFIEDTIME;

@property (nonatomic, copy) NSString *CREATEDTIME;

@property (nonatomic, copy) NSString *PRECAUTIONS;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *CREATEDBY;

@property (nonatomic, copy) NSString *CAT_NAME;

@property (nonatomic, copy) NSString *INSTRUCTIONS;

@property (nonatomic, assign) NSInteger DRUG_TYPE;

@property (nonatomic, copy) NSString *PICTURE_URL;

@property (nonatomic, copy) NSString *PRICE;

@property (nonatomic, copy) NSString *DOSAGE_FORM;

@property (nonatomic, copy) NSString *COMPOSITION;

@property (nonatomic, copy) NSString *WOMEN_MEDICATION;

@property (nonatomic, copy) NSString *CHILD_MEDICATION;

@property (nonatomic, copy) NSString *DRUG_INTERACTION;

@property (nonatomic, copy) NSString *NOTICE;

@property (nonatomic, copy) NSString *ELDERLY_MEDICATION;

@property (nonatomic, strong) NSArray<DiseaseList *> *DiseaseList;

@end

@interface DiseaseList : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *Disease_Name;

@end
