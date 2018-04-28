//
//  BATEatDetailsModel.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEatDetailsModel.h"

@implementation BATEatDetailsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end

@implementation BATEatData
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATEatData class]};
}

@end
