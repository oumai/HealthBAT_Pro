//
//  BATDrugOrderInfoModel.h
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
BATDrugOrderInfoDataModel,
BATDrugOrderInfoRecipeFilesModel,
BATDrugOrderInfoDetailsModel,
BATDrugOrderInfoDrugModel,
BATDrugOrderInfoDiagnosesModel,
BATDrugOrderInfoDiagnosesDetailModel;

@interface BATDrugOrderInfoModel : NSObject

@property (nonatomic, strong) BATDrugOrderInfoDataModel *Data;
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, assign) NSInteger Total;
@property (nonatomic, copy) NSString *Msg;

@end

@interface BATDrugOrderInfoDataModel : NSObject

@property (nonatomic, copy) NSString *OPDRegisterID;
@property (nonatomic, copy) NSString *BillInNo;
@property (nonatomic, copy) NSArray<BATDrugOrderInfoRecipeFilesModel *> *RecipeFiles;
@property (nonatomic, assign) BOOL Deletable;
@property (nonatomic, assign) BOOL Cancelable;
@property (nonatomic, copy) NSString *RecipeOrderID;

@end

@interface BATDrugOrderInfoRecipeFilesModel : NSObject

@property (nonatomic, copy) NSArray<BATDrugOrderInfoDetailsModel *> *Details;
@property (nonatomic, copy) NSString *FreqDay;
@property (nonatomic, copy) NSString *RecipeFileID;
@property (nonatomic, copy) NSString *RecipeDate;
@property (nonatomic, copy) NSString *RecipeName;
@property (nonatomic, copy) NSString *RecipeType;
@property (nonatomic, copy) NSString *FreqTimes;
@property (nonatomic, copy) NSString *RecipeImgUrl;
@property (nonatomic, copy) NSString *DoctorID;
@property (nonatomic, copy) NSString *BoilWay;
@property (nonatomic, copy) NSString *DecoctTargetWater;
@property (nonatomic, copy) NSString *ReplacePrice;
@property (nonatomic, copy) NSString *ReplaceDose;
@property (nonatomic, copy) NSString *RecipeFileStatus;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *Usage;
@property (nonatomic, copy) NSString *OPDRegisterID;
@property (nonatomic, copy) NSString *RecipeTypeName;
@property (nonatomic, copy) NSString *TCMQuantity;
@property (nonatomic, copy) NSString *MemberID;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *Times;
@property (nonatomic, copy) NSString *DecoctNum;
@property (nonatomic, copy) NSString *RecipeNo;
@property (nonatomic, copy) NSString *DecoctTotalWater;
@property (nonatomic, copy) NSString *SignatureID;
@property (nonatomic, assign) double Amount;
@property (nonatomic, copy) NSArray<BATDrugOrderInfoDiagnosesModel *> *Diagnoses;

@end

@interface BATDrugOrderInfoDetailsModel : NSObject

@property (nonatomic, copy) NSString *DrugRouteName;
@property (nonatomic, copy) NSString *Frequency;
@property (nonatomic, copy) NSString *Dose;
@property (nonatomic, copy) NSString *Quantity;
@property (nonatomic, strong) BATDrugOrderInfoDrugModel *Drug;

@end

@interface BATDrugOrderInfoDrugModel : NSObject

@property (nonatomic, copy) NSString *DrugType;
@property (nonatomic, copy) NSString *DoseUnit;
@property (nonatomic, copy) NSString *HasEphedrine;
@property (nonatomic, assign) double UnitPrice;
@property (nonatomic, copy) NSString *ChannelPrice;
@property (nonatomic, copy) NSString *Unit;
@property (nonatomic, copy) NSString *IsInsured;
@property (nonatomic, copy) NSString *DrugID;
@property (nonatomic, copy) NSString *DrugName;
@property (nonatomic, copy) NSString *Specification;
@property (nonatomic, copy) NSString *TotalDose;
@property (nonatomic, copy) NSString *IsNeedSign;
@property (nonatomic, copy) NSString *IsRepeat;
@property (nonatomic, copy) NSString *DrugCode;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *IsPrescribed;
@property (nonatomic, copy) NSString *OriginalPrice;
@property (nonatomic, copy) NSString *ValidateState;
@property (nonatomic, copy) NSString *PinYinName;

@end

@interface BATDrugOrderInfoDiagnosesModel : NSObject

@property (nonatomic, copy) NSString *IsPrimary;
@property (nonatomic, strong) BATDrugOrderInfoDiagnosesDetailModel *Detail;
@property (nonatomic, copy) NSString *Description;

@end

@interface BATDrugOrderInfoDiagnosesDetailModel : NSObject

@property (nonatomic, copy) NSString *DiagnoseType;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *DiseaseCode;
@property (nonatomic, copy) NSString *DiagnoseID;
@property (nonatomic, copy) NSString *DiseaseName;
@property (nonatomic, copy) NSString *IsPrimary;

@end
