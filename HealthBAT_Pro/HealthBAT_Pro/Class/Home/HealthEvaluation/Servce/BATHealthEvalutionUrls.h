//
//  BATHealthEvalutionUrls.h
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATHealthEvalutionUrls : NSObject

#define BATHealthEvalutionUrl @"/api/HealthManager/GetHealthAssessmentRecord"

//获取饮食详情  get
#define BATHealthEatDetailsUrl @"/api/EatCircle/GetDietDetails"

//更新健康数据 post
#define BATUpdateHealthInfoUrl @"/api/EatCircle/UpdateHealthData"

//获取健康数据 get
#define BATGetHealthInfoUrl @"/api/EatCircle/GetHealthData"

//分词查询食物 get更精确的
#define BATGetGetSearchEatInfoUrl @"/api/EatCircle/GetRecommendFoodList"

//分词查询食物 get更精确的
#define BATMoHuGetSearchEatInfoUrl @"/api/EatCircle/GetAssociationFood"


//健康评估 get
#define BATHealthyAssessUrl @"/api/HealthManager/GetHealthThreeSecondRecord"
@end
