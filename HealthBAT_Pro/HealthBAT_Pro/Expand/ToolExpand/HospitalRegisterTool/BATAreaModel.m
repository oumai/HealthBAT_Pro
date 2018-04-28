//
//  AreaModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAreaModel.h"

@implementation BATAreaModel
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATAreaData class]};
}
@end


@implementation BATAreaData
MJExtensionCodingImplementation
@end


