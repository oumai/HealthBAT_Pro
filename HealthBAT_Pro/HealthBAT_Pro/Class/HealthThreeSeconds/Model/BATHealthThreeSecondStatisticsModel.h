//
//  BATHealthThreeSecondStatisticsModel.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATHealthThreeSecondStatisticsModel : NSObject
@property (nonatomic ,strong) NSMutableDictionary                        *DietData;
@property (nonatomic ,strong) NSMutableDictionary                        *DrinkData;
@property (nonatomic ,strong) NSMutableDictionary                        *StepsData;
@property (nonatomic ,strong) NSMutableDictionary                        *SleepData;
+ (instancetype)healthThreeSecondStatisticsModelWith:(id)values;
@end
