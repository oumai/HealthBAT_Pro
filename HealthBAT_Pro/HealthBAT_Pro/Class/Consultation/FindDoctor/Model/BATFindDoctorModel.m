//
//  BATFindDoctorModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindDoctorModel.h"

@implementation BATFindDoctorModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATFindDoctorData class]};
}
@end
@implementation BATFindDoctorData

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [BATFindDoctorServices class]};
}

@end


@implementation BATFindDoctorUser

@end


@implementation BATFindDoctorServices

@end


