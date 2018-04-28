//
//  BATNearFamilyDoctorModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNearFamilyDoctorModel.h"

@implementation BATNearFamilyDoctorModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATNearFamilyDoctorData class]};
}
@end

@implementation BATNearFamilyDoctorData
MJExtensionCodingImplementation
@end
