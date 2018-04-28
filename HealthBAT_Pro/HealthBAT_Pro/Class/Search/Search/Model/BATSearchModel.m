//
//  SearchModel.m
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchModel.h"

@implementation BATSearchModel

@end
@implementation SearchData

@end


@implementation Resultentity

@end


@implementation Treatmentresult

+ (NSDictionary *)objectClassInArray{
    return @{@"TreatmentList" : [TreatmentList class]};
}
@end

@implementation TreatmentList


@end

@implementation Doctorresult

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorList" : [DoctorList class]};
}
@end

@implementation DoctorList


@end

@implementation Informationresult

+ (NSDictionary *)objectClassInArray{
    return @{@"InformationList" : [Informationlist class]};
}

@end


@implementation Informationlist

@end


@implementation Hospitalresult
+ (NSDictionary *)objectClassInArray{
    return @{@"HospitalList" : [HospitalList class]};
}
@end

@implementation HospitalList

@end

@implementation Conditionresult

+ (NSDictionary *)objectClassInArray{
    return @{@"ConditionList" : [ConditionList class]};
}
@end

@implementation ConditionList



@end

