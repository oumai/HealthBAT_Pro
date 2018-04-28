//
//  BATHealthPlanModel.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthPlanModel.h"

@implementation BATHealthPlanModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [HealthPlanVideData class]};
}

@end

@implementation HealthPlanVideData

+ (NSDictionary *)objectClassInArray{
    return @{@"VideoLst" : [Video class]};
}
@end

@implementation Video

@end
