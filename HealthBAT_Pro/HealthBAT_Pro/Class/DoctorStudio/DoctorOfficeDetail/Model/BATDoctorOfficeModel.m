//
//  BATDoctorOfficeModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorOfficeModel.h"

@implementation BATDoctorOfficeModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [DoctorOfficeDetail class]};
}

@end

@implementation DoctorOfficeDetail

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorService" : [DoctorOfficeDetail class]};
}


@end

@implementation DoctorService



@end
