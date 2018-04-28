//
//  BATFreeClinicDoctorModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFreeClinicDoctorModel.h"

@implementation BATFreeClinicDoctorModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [FreeClinicDoctorData class]};
}
@end
@implementation FreeClinicDoctorData

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [FreeClinicDoctorservices class]};
}

@end


@implementation FreeClinicDoctorclinic

@end


@implementation FreeClinicDoctorUser

@end


@implementation FreeClinicDoctorservices

@end


