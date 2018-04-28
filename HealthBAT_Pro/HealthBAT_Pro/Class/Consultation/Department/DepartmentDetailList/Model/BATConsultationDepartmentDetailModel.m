//
//  BATConsultationDepartmentDetailModel.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentDetailModel.h"

@implementation BATConsultationDepartmentDetailModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [ConsultationDepartmentDetailData class]};
}
@end
@implementation ConsultationDepartmentDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [ConsultationDepartmentDoctorServices class]};
}

@end


@implementation ConsultationDepartmentDoctorUser

@end


@implementation ConsultationDepartmentDoctorServices

@end

//@implementation BATConsultationDepartmentDetailModel
//
//
//+ (NSDictionary *)objectClassInArray{
//    return @{@"Data" : [ConsultationDepartmentDetailData class]};
//}
//@end
//@implementation ConsultationDepartmentDetailData
//
//@end


