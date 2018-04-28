//
//  BATHealthThreeSecondStatisticsModel.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondStatisticsModel.h"

@implementation BATHealthThreeSecondStatisticsModel
+ (instancetype)healthThreeSecondStatisticsModelWith:(id)values {
    NSDictionary *dataDict = [values jk_dictionaryForKey:@"Data"];
    if (dataDict) {
        BATHealthThreeSecondStatisticsModel *statisticsModel = [[BATHealthThreeSecondStatisticsModel alloc] init];
        statisticsModel.DietData = [NSMutableDictionary dictionaryWithDictionary:[dataDict jk_dictionaryForKey:@"DietData"]];
        statisticsModel.DrinkData = [NSMutableDictionary dictionaryWithDictionary:[dataDict jk_dictionaryForKey:@"DrinkData"]];
        statisticsModel.StepsData = [NSMutableDictionary dictionaryWithDictionary:[dataDict jk_dictionaryForKey:@"StepsData"]];
        statisticsModel.SleepData = [NSMutableDictionary dictionaryWithDictionary:[dataDict jk_dictionaryForKey:@"SleepData"]];
        return statisticsModel;
    }
    return nil;
}
@end
