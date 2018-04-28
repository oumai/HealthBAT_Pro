//
//  BATMyProgrammesModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyProgrammesModel.h"

@implementation BATMyProgrammesModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [ProgrammesData class]};
}

@end


@implementation ProgrammesData

+ (NSDictionary *)objectClassInArray{
    return @{@"ProgrammeLst" : [BATProgramItem class]};
}

@end
