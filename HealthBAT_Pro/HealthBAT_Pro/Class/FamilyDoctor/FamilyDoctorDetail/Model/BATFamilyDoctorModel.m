//
//  BATFamilyDoctorModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorModel.h"

@implementation BATFamilyDoctorModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATFamilyDoctorDetailData class]};
}
@end


@implementation BATFamilyDoctorDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"FamilyDoctorCost" : [BATFamilyDoctorServiceCostData class]};
}
@end


//@implementation BATFamilyDoctorServiceData
//MJExtensionCodingImplementation
//@end


@implementation BATFamilyDoctorServiceCostData
MJExtensionCodingImplementation
@end
