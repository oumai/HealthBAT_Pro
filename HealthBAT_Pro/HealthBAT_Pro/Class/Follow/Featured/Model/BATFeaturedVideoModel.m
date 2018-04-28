//
//  BATFeaturedVideoModel.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFeaturedVideoModel.h"

@implementation BATFeaturedVideoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Data" : [BATFeaturedVideoListModel class]};
}
@end

@implementation BATFeaturedVideoListModel

@end
