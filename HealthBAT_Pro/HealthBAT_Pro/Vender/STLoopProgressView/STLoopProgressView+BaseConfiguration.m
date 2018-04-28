//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return UIColorFromHEX(0x0182eb, 1);
}

+ (UIColor *)centerColor {
    
    return [UIColor yellowColor];
}

+ (UIColor *)endColor {
    
    return UIColorFromHEX(0x0ee7fb, 1);
}

+ (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:233.0f / 255.0 green:233.0f / 255.0 blue:233.0f / 255.0 alpha:0.5];
}

+ (CGFloat)lineWidth {
    
    return 20;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(270);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(630);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
