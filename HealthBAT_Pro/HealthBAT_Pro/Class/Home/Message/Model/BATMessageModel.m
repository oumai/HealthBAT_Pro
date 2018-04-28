//
//  BATMessageModel.m
//  HealthBAT_Pro
//
//  Created by four on 16/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMessageModel.h"

@implementation BATMessageModel

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATMessagesData class]};
}

@end

@implementation BATMessagesData

@end
