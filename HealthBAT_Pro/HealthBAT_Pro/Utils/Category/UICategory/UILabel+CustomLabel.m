//
//  UILabel+CustomLabel.m
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligment {

    UILabel * label = [[UILabel alloc] init];

    [label setFont:font];
    [label setTextColor:textColor];
    [label setTextAlignment:textAligment];

    [label sizeToFit];
    
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)frame fontSize:(double)size text:(NSString *)text textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.text = text;
    label.textColor = color;
    return label;
}

@end
