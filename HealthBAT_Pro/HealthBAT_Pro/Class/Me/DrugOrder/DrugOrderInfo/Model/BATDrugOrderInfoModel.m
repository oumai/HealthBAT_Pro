//
//  BATDrugOrderInfoModel.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderInfoModel.h"

@implementation BATDrugOrderInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATDrugOrderInfoDataModel class]};
}

@end

@implementation BATDrugOrderInfoDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"RecipeFiles" : [BATDrugOrderInfoRecipeFilesModel class]};
}

@end

@implementation BATDrugOrderInfoRecipeFilesModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"Details" : [BATDrugOrderInfoDetailsModel class],
             @"Diagnoses" : [BATDrugOrderInfoDiagnosesModel class]
             };
}

@end

@implementation BATDrugOrderInfoDetailsModel

@end

@implementation BATDrugOrderInfoDrugModel

@end

@implementation BATDrugOrderInfoDiagnosesModel

@end

@implementation BATDrugOrderInfoDiagnosesDetailModel

@end

