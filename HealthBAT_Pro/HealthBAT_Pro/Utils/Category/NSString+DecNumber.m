//
//  NSString+DecNumber.m
//  HealthBAT_Pro
//
//  Created by mac on 2017/12/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "NSString+DecNumber.h"

@implementation NSString (DecNumber)

+ (NSString *)decimalNumberWithDouble:(double)conversionValue {
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
