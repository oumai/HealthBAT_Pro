//
//  BATDrugOrderListModel.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderListModel.h"

@implementation BATDrugOrderListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATDrugOrderListDataModel class]};
}

@end

@implementation BATDrugOrderListDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"RecipeFiles" : [BATDrugOrderListRecipeFilesModel class]};
}

@end

@implementation BATDrugOrderListOPDRegisterModel

@end

@implementation BATDrugOrderListOrderModel

@end

@implementation BATDrugOrderListRecipeFilesModel

@end

@implementation BATDrugOrderListMember

@end

@implementation BATDrugOrderListDoctor

@end
