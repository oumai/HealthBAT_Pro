//
//  BATHealthEvalutionModel.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthEvalutionModel.h"

@implementation BATHealthEvalutionModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionReturnDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
+ (NSDictionary *)objectClassInArray{
    return @{@"HealthDeseaseCategoryList" : [BATHealthEvalutionHealthDeseaseCategoryListModel class]};
}

@end



@implementation BATHealthEvalutionPersonDeseaseCategoryModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end


@implementation BATHealthEvalutionHealthDeseaseCategoryListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionSportAdviceModel  //运动建议
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
+ (NSDictionary *)objectClassInArray{
    return @{@"SportWeekPlanDetailList" : [BATHealthEvalutionSportWeekPlanDetailListModel class]};
}

@end

@implementation BATHealthEvalutionSportWeekPlanDetailListModel   //运动详细建议
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionDietAdviceModel   //饮食建议
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionDietAdviseDetailModel  //饮食详细建议
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionSocialResultModel  //社会健康评估结果
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATHealthEvalutionPsychologyResultModel  //生理健康评估结果
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
