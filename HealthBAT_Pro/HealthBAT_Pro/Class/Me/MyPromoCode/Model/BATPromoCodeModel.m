//
//  BATPromoCodeModel.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPromoCodeModel.h"

@implementation BATPromoCodeModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [BATPrommoCodeData class]};
}
@end


@implementation BATPrommoCodeData : NSObject
MJExtensionCodingImplementation
@end
