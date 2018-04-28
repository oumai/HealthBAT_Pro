//
//  BATSelfDiagnosisModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/10/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSelfDiagnosisModel.h"

@implementation BATSelfDiagnosisModel

@end
@implementation DiagnoisiData

+ (NSDictionary *)objectClassInArray{
    return @{@"partsCategoryList" : [Partscategorylist class]};
}

@end


@implementation Partscategorylist

+ (NSDictionary *)objectClassInArray{
    return @{@"partsItemList" : [Partsitemlist class]};
}

@end


@implementation Partsitemlist

+ (NSDictionary *)objectClassInArray{
    return @{@"disList" : [Dislist class]};
}

@end


@implementation Dislist

@end


