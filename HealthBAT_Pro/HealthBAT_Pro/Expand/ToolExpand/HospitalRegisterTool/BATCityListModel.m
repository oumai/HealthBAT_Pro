//
//  CityListModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCityListModel.h"

@implementation BATCityListModel
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATCityData class]};
}

@end

@implementation BATCityData
MJExtensionCodingImplementation
@end


