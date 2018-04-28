//
//  BATOTCOrderDetailModel.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/19.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATOTCOrderDetailModel.h"

@implementation BATOTCOrderDetailModel

@end

@implementation BATOTCConfirmOrderData

+ (NSDictionary *)objectClassInArray{
    return @{@"Details" : [DetailModel class]};
}

@end

@implementation DetailModel

@end

@implementation ConsigneeModel

@end
