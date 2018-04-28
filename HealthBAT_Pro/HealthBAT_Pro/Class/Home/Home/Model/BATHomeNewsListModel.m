//
//  BATHomeNewsListModel.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/202016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewsListModel.h"

@implementation BATHomeNewsListModel

@end
@implementation HomeNewsListResultdata

+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [HomeNewsContent class]};
}

@end


@implementation HomeNewsContent

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}

@end


