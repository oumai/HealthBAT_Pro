//
//  BATFamilyDoctorOrderDetailModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorOrderDetailModel.h"

@implementation BATFamilyDoctorOrderDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATFamilyDoctorOrderDetailData class]};
}
@end


@implementation BATFamilyDoctorOrderDetailData : NSObject
MJExtensionCodingImplementation
@end
