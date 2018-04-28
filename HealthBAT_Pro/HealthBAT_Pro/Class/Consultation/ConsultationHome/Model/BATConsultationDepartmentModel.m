//
//  BATDepartmentListModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATConsultationDepartmentModel.h"

@implementation BATConsultationDepartmentModel

MJExtensionCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [ConsultationDepartmentData class]};
}

@end
@implementation ConsultationDepartmentData
MJExtensionCodingImplementation
@end



