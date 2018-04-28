//
//  BATTrainStudioDoctorModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioDoctorModel.h"

@implementation BATTrainStudioDoctorModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATTrainStudioDoctorData class]};
}
@end

@implementation BATTrainStudioDoctorData
MJExtensionCodingImplementation
@end
