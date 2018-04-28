//
//  BATAVModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAVModel.h"

@implementation BATAVModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [VideoData class]};
}
@end
@implementation VideoData

@end


@implementation VideoSchedule

@end


@implementation VideoRoom

@end


@implementation VideoDoctor

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [VideoDoctorservices class]};
}

@end


@implementation VideoUser

@end


@implementation VideoDoctorservices

@end


@implementation VideoOrder

@end


@implementation VideoMember

@end


