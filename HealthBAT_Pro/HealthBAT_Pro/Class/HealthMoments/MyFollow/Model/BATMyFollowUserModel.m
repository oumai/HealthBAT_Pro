//
//  BATMyFollowUserModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMyFollowUserModel.h"

@implementation BATMyFollowUserModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATMyFollowUserData class]};
}
@end

@implementation BATMyFollowUserData

@end