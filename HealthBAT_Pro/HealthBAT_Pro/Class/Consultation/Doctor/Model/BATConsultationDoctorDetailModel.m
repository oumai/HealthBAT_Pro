//
//  BATConsultationDoctorDetailModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorDetailModel.h"

@implementation BATConsultationDoctorDetailModel

@end


@implementation ConsultationDoctorDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [ConsultationDoctorDetailDoctorservices class]};
}

@end


@implementation ConsultationDoctorDetailUser

@end


@implementation ConsultationDoctorDetailDoctorservices

@end


