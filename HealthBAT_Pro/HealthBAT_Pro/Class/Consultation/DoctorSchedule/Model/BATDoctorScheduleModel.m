//
//  BATDoctorScheduleModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleModel.h"

@implementation BATDoctorScheduleModel

@end
@implementation DoctorScheduleData

+ (NSDictionary *)objectClassInArray{
    return @{@"DateWeekList" : [Dateweeklist class], @"ScheduleList" : [Schedulelist class]};
}

@end


@implementation Dateweeklist

@end


@implementation Schedulelist

+ (NSDictionary *)objectClassInArray{
    return @{@"RegNumList" : [Regnumlist class]};
}

@end


@implementation Regnumlist

@end


