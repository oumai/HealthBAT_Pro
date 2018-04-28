//
//  BATFamilyDoctorOrderModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderModel.h"

@implementation BATFamilyDoctorOrderModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATFamilyDoctorOrderData class]};
}
@end


@implementation BATFamilyDoctorOrderData
MJExtensionCodingImplementation
@end
