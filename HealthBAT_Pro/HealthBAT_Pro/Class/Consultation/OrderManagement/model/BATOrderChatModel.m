//
//  BATOrderChatModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATOrderChatModel.h"

@implementation BATOrderChatModel


+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [OrderResData class]};
}
@end
@implementation OrderResData

+ (NSDictionary *)objectClassInArray{
    return @{@"Messages" : [Messages class]};
}

@end


@implementation Usermember

@end


@implementation Room

@end


@implementation Doctor

+ (NSDictionary *)objectClassInArray{
    return @{@"DoctorServices" : [Doctorservices class]};
}

@end


@implementation Doctorservices

@end


@implementation Order

@end


@implementation User

@end


@implementation Messages

@end


