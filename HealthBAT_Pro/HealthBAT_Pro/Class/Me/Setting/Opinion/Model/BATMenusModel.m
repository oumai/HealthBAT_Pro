//
//  MenusModel.m
//  HealthBAT
//
//  Created by KM on 16/6/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMenusModel.h"

@implementation BATMenusModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATMenuData class]};
}
@end

@implementation BATMenuData

+ (NSDictionary *)objectClassInArray{
    return @{@"SubMenus" : [BATSubmenus class]};
}

@end

@implementation BATSubmenus

@end


