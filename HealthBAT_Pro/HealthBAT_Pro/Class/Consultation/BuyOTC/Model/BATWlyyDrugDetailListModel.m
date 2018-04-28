//
//  BATWlyyDrugDetailListModel.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWlyyDrugDetailListModel.h"

@implementation BATWlyyDrugDetailListModel


@end

@implementation BATKmWlyyDetailListData

+ (NSDictionary *)objectClassInArray{
    return @{@"RecipeFiles" : [DetailRecipeFile class]};
}

@end

@implementation DetailRecipeFile
+ (NSDictionary *)objectClassInArray{
    return @{@"Details" : [Details class]};
}
@end

@implementation Details


@end

@implementation Drug


@end

