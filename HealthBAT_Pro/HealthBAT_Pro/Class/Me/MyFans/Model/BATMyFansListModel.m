//
//  BATMyFansListModel.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFansListModel.h"

@implementation BATMyFansListModel

@end

@implementation BATMyFansSubModel : NSObject

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Data" : [BATMyFansListModel class]};
}
@end
