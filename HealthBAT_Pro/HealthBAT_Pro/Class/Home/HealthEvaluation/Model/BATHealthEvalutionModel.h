//
//  BATHealthEvalutionModel.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BATHealthEvalutionReturnDataModel;
@class BATHealthEvalutionPersonDeseaseCategoryModel; //个人疾病分类
@class BATHealthEvalutionHealthDeseaseCategoryListModel;//健康疾病分类
@class BATHealthEvalutionSportAdviceModel;
@class BATHealthEvalutionDietAdviceModel;
@class BATHealthEvalutionDietAdviseDetailModel;
@class BATHealthEvalutionSportWeekPlanDetailListModel;//运动详细建议
@class BATHealthEvalutionSocialResultModel;
@class BATHealthEvalutionPsychologyResultModel;
@interface BATHealthEvalutionModel : NSObject
@property (nonatomic, copy) NSString *ReturnMessage;
@property (nonatomic, assign) NSInteger *IsSuccess;
@property (nonatomic, strong) BATHealthEvalutionReturnDataModel *ReturnData;
@end

@interface BATHealthEvalutionReturnDataModel : NSObject
@property (nonatomic, strong) BATHealthEvalutionPersonDeseaseCategoryModel *PersonDeseaseCategory;
@property (nonatomic, strong) NSArray<BATHealthEvalutionHealthDeseaseCategoryListModel *> *HealthDeseaseCategoryList;
@property (nonatomic, strong) BATHealthEvalutionSportAdviceModel *SportAdvice;
@property (nonatomic, strong) BATHealthEvalutionDietAdviceModel *DietAdvice;
@property (nonatomic, strong) BATHealthEvalutionDietAdviseDetailModel *DietAdviseDetail;
@property (nonatomic, strong) BATHealthEvalutionSocialResultModel *SocialResult;
@property (nonatomic, strong) BATHealthEvalutionPsychologyResultModel *PsychologyResult;
@end

@interface BATHealthEvalutionPersonDeseaseCategoryModel: NSObject

@property (nonatomic, assign) NSInteger PhysiologicalHealth;

@property (nonatomic, assign) NSInteger HealthScore;

@property (nonatomic, copy) NSString *DeseaseCategoryTime;

@property (nonatomic, copy) NSString *HealthGrade;
@end


@interface BATHealthEvalutionHealthDeseaseCategoryListModel : NSObject

@property (nonatomic, assign) NSInteger HealthDeseaseID;

@property (nonatomic, assign) NSInteger DangerLevelID;

@property (nonatomic, assign) NSInteger SlowDisease;

@property (nonatomic, copy) NSString *HealthDeseaseName;

@property (nonatomic, copy) NSString *DangerLevelName;

@end

@interface BATHealthEvalutionSportAdviceModel : NSObject//运动建议
@property (nonatomic, strong) NSArray<BATHealthEvalutionSportWeekPlanDetailListModel *> *SportWeekPlanDetailList;

@property (nonatomic, assign) double Fat;

@property (nonatomic, copy) NSString *SportContent;

@property (nonatomic, assign) BOOL IsAssess;

@property (nonatomic, strong) NSArray *EvaluateErrorList;

@property (nonatomic, assign) NSInteger HeartRate;

@property (nonatomic, assign) NSInteger Calory;
@end

@interface BATHealthEvalutionSportWeekPlanDetailListModel : NSObject //运动详细建议

@property (nonatomic, assign) NSInteger SportType;

@property (nonatomic, assign) NSInteger SportTimeMin;

@property (nonatomic, assign) NSInteger SportTimeMax;

@property (nonatomic, copy) NSString *SportTime;

@property (nonatomic, copy) NSString *WeekName;

@property (nonatomic, copy) NSString *SportIcon;

@property (nonatomic, copy) NSString *sportfullicon;
@end

@interface BATHealthEvalutionDietAdviceModel : NSObject //饮食建议
@property (nonatomic, assign) NSInteger DietCalory;

@property (nonatomic, copy) NSString *BMIDescription;

@property (nonatomic, copy) NSString *Tip;

@property (nonatomic, assign) double BMI;

@property (nonatomic, assign) double Potato;

@property (nonatomic, assign) double Vegetables;

@property (nonatomic, assign) double MeatEgg;

@property (nonatomic, assign) double SoyMilk;

@property (nonatomic, assign) double Fruits;

@property (nonatomic, assign) double Fats;
@end

@interface BATHealthEvalutionDietAdviseDetailModel : NSObject//饮食详细建议

@property (nonatomic, assign) double Rice;

@property (nonatomic, assign) double SteamedBun;

@property (nonatomic, assign) double Meat;

@property (nonatomic, assign) double Egg;

@property (nonatomic, assign) double Fish;

@property (nonatomic, assign) double Tofu;

@property (nonatomic, assign) double DriedTofu;

@property (nonatomic, assign) NSInteger Potato;

@property (nonatomic, assign) NSInteger ChineseCabbage;

@property (nonatomic, assign) NSInteger Pumpkin;

@property (nonatomic, assign) NSInteger Carrot;

@property (nonatomic, assign) NSInteger Milk;

@property (nonatomic, assign) NSInteger Apple;

@property (nonatomic, assign) NSInteger Banana;

@property (nonatomic, assign) NSInteger Watermelon;

@property (nonatomic, assign) NSInteger Oil;
@end

@interface BATHealthEvalutionSocialResultModel : NSObject//社会健康评估结果
@property (nonatomic, assign) NSInteger Score;

@property (nonatomic, assign) NSInteger Item1;

@property (nonatomic, assign) NSInteger Item2;

@property (nonatomic, assign) NSInteger Item3;

@property (nonatomic, copy) NSString *AppGeneralConclusion;

@property (nonatomic, copy) NSString *AppBehaviorSuggestion;


@end

@interface BATHealthEvalutionPsychologyResultModel : NSObject//生理健康评估结果
@property (nonatomic, assign) NSInteger Score;

@property (nonatomic, assign) NSInteger Item1;

@property (nonatomic, assign) NSInteger Item2;

@property (nonatomic, assign) NSInteger Item3;

@property (nonatomic, assign) NSInteger Item4;

@property (nonatomic, copy) NSString *AppGeneralConclusion;

@property (nonatomic, copy) NSString *AppBehaviorSuggestion;
@end


