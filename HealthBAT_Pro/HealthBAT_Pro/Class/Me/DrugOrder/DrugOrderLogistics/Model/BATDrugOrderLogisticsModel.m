//
//  BATDrugOrderLogisticsModel.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderLogisticsModel.h"

@implementation BATDrugOrderLogisticsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATDrugOrderLogisticsDataModel class]};
}

@end

@implementation BATDrugOrderLogisticsDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Details" : [BATDrugOrderLogisticsDetailsModel class]};
}

@end

@implementation BATDrugOrderLogisticsDetailsModel

@end

@implementation BATDrugOrderLogisticsConsigneeModel

@end
