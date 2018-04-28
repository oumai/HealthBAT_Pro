//
//  BATHotDoctorListModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDoctorModel.h"

@implementation BATConsultationDoctorModel



+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [ConsultationDoctorData class]};
}
@end

//@implementation BATConsultationDoctorModel
//
//
//+ (NSDictionary *)objectClassInArray{
//    return @{@"Data" : [ConsultationDoctorData class]};
//}
//@end
//@implementation ConsultationDoctorData
//
//+ (NSDictionary *)objectClassInArray{
//    return @{@"Doctors" : [ConsultationDoctors class]};
//}
//
//@end
//
//
//@implementation ConsultationDoctors
//
//@end


@implementation ConsultationDoctorData

+ (NSDictionary *)objectClassInArray{
    return @{@"Doctors" : [ConsultationDoctors class]};
}

@end


@implementation ConsultationDoctors

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [CosultaionDoctorservices class]};
}

@end


@implementation ConsultationDoctorUser

@end


@implementation CosultaionDoctorservices

@end


