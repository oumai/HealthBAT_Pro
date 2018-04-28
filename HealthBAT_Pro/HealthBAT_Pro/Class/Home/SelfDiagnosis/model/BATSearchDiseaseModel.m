//
//  BATSearchDiseaseModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/11/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchDiseaseModel.h"

@implementation BATSearchDiseaseModel


+ (NSDictionary *)objectClassInArray{
    return @{@"resultData" : [DiseaseData class]};
}
@end
@implementation DiseaseData

+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [DiseaseContent class]};
}

@end


@implementation DiseaseContent

@end
