//
//  BATAddressModel.m
//  HealthBAT
//
//  Created by cjl on 16/3/16.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddressModel.h"

@implementation BATAddressModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATAddressData class]};
}

@end

@implementation BATAddressData

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID" : @"Id",
             };
}

@end



