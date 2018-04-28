//
//  UITextView+Placeholder.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

@import UIKit;

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (Placeholder)

/**
 可以通过这个属性设置占位文字的颜色，和大小
 
 */
@property (nonatomic, readonly) UILabel *placeholderLabel;

/**
 占位文字
 
 */
@property (nonatomic, strong) IBInspectable NSString *placeholder;

/**
 为 textView的文字增加富文本属性（字体/字体颜色）
 
 */
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
/**
 占位文字的颜色
 
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
