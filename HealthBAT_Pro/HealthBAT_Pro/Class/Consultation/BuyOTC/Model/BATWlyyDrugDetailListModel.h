//
//  BATWlyyDrugDetailListModel.h
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATKmWlyyDetailListData,DetailRecipeFile,Details,Drug;

@interface BATWlyyDrugDetailListModel : NSObject

@property (nonatomic, copy  ) NSString          *ResultMessage;

@property (nonatomic, assign) NSInteger         ResultCode;

@property (nonatomic, assign) NSInteger         Status;

@property (nonatomic, assign) NSInteger         Total;

@property (nonatomic, strong) BATKmWlyyDetailListData *Data;

@end


@interface BATKmWlyyDetailListData : NSObject


@property (nonatomic, copy  ) NSString          *RecipeFileUrl;

@property (nonatomic, copy  ) NSString          *RecipeOrderID;

@property (nonatomic, strong) NSMutableArray<DetailRecipeFile *> *RecipeFiles;

@end

@interface DetailRecipeFile : NSObject

@property (nonatomic, copy  ) NSString          *Amount;  //1.05

@property (nonatomic, copy  ) NSString          *BoilWay;

@property (nonatomic, copy  ) NSString          *DecoctNum;

@property (nonatomic, copy  ) NSString          *DecoctTargetWater;

@property (nonatomic, copy  ) NSString          *DecoctTotalWater;

@property (nonatomic, copy  ) NSString          *FreqDay;

@property (nonatomic, copy  ) NSString          *FreqTimes;

@property (nonatomic, copy  ) NSString          *RecipeDate;   //处方日期

@property (nonatomic, copy  ) NSString          *RecipeFileID; //处方编号

@property (nonatomic, copy  ) NSString          *RecipeFileStatus;//处方状态

@property (nonatomic, copy  ) NSString          *RecipeImgUrl;

@property (nonatomic, copy  ) NSString          *RecipeName;  //处方名称

@property (nonatomic, copy  ) NSString          *RecipeNo;

@property (nonatomic, copy  ) NSString          *RecipeType; //1=中药，2=西药

@property (nonatomic, copy  ) NSString          *RecipeTypeName;

@property (nonatomic, copy  ) NSString          *Remark;

@property (nonatomic, copy  ) NSString          *ReplaceDose;

@property (nonatomic, copy  ) NSString          *ReplacePrice;

@property (nonatomic, copy  ) NSString          *State;

@property (nonatomic, copy  ) NSString          *TCMQuantity;

@property (nonatomic, copy  ) NSString          *Times;

@property (nonatomic, copy  ) NSString          *Usage;

@property (nonatomic, copy  ) NSString          *OPDRegisterID;

@property (nonatomic, strong) NSMutableArray<Details *> *Details;


@end

@interface Details : NSObject

@property (nonatomic, strong) NSString *Dose;
@property (nonatomic, strong) NSString *Frequency;
@property (nonatomic, assign) NSInteger Quantity;
@property (nonatomic, strong) NSString *DrugRouteName;
@property (nonatomic, strong) Drug *Drug;

@end


@interface Drug : NSObject

@property (nonatomic, strong) NSString *DrugID;
@property (nonatomic, strong) NSString *DrugName;
@property (nonatomic, strong) NSString *DrugType;
@property (nonatomic, strong) NSString *DrugCode;
@property (nonatomic, strong) NSString *Unit;
@property (nonatomic, strong) NSString *UnitPrice;
@property (nonatomic, strong) NSString *TotalDose;
@property (nonatomic, strong) NSString *DoseUnit;
@property (nonatomic, strong) NSString *Specification;
@property (nonatomic, strong) NSString *PinYinName;


@end
