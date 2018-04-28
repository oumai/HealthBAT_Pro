//
//  BATDiteGuideDetailModel.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/11/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailModel.h"

@implementation BATDiteGuideDetailEatSuggestModel

@end

@implementation BATDiteGuideDetailGenerationMealModel

@end

@implementation BATDiteGuideDetailSportSuggestModel

@end

@implementation BATDiteGuideDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{@"EatSuggest"     : [BATDiteGuideDetailEatSuggestModel class],
             @"GenerationMeal" : [BATDiteGuideDetailGenerationMealModel class],
             @"SportSuggest"   : [BATDiteGuideDetailSportSuggestModel class]};
}
@end
