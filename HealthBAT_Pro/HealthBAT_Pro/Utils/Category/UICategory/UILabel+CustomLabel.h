//
//  UILabel+CustomLabel.h
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CustomLabel)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligment;
+ (UILabel*)labelWithFrame:(CGRect)frame fontSize:(double)size text:(NSString*)text textColor:(UIColor*)color;
@end
