//
//  BATSymptomModel.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/28.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSymptomModel.h"

@implementation BATSymptomModel

@end

@implementation symptomData

+ (NSDictionary *)objectClassInArray{
    return @{@"AboutDiseaseList" : [DiseaseListDetail class], @"AboutSymptomList" : [AboutSymptomListDetail class]};
}

@end

@implementation AboutSymptomListDetail

@end

@implementation DiseaseListDetail

@end
