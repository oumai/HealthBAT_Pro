//
//  BATtest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/242016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchResultModel.h"

@implementation BATSearchResultModel


+ (NSDictionary *)objectClassInArray{
    return @{@"resultData" : [SearchResultdata class]};
}
@end
@implementation SearchResultdata

+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [SearchContent class]};
}

@end


@implementation SearchContent

@end


