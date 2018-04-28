//
//  BATNewDoctorScheduleModel.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewDoctorScheduleModel.h"

@implementation BATNewDoctorScheduleModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [NewDoctorScheduleData class]};
}

@end

@implementation NewDoctorScheduleData

+ (NSDictionary *)objectClassInArray{
    return @{@"DataWeek" : [NewDataWeek class]};
}

@end



@implementation NewDataWeek


@end


//@implementation NewScheduleTimeList
//
//+ (NSDictionary *)objectClassInArray{
//    return @{@"ScheduleTimeList" : [NewScheduleTimeList class]};
//}
//
//@end

