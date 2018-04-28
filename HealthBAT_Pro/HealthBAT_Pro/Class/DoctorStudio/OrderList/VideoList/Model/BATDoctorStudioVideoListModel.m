//
//  BATDoctorStudioVideoListModel.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorStudioVideoListModel.h"

@implementation BATDoctorStudioVideoListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [DoctorStudioVideoOrderData class]};
}
@end

@implementation DoctorStudioVideoOrderData

@end
