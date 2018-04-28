//
//  BATTrainStudioCourseModel.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioCourseModel.h"

@implementation BATTrainStudioCourseModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATTrainStudioCourseData class]};
}
@end

@implementation BATTrainStudioCourseData
MJExtensionCodingImplementation
@end
