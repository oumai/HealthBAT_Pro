//
//  BATTextView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/4.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTextView : UITextView
@property (nonatomic, assign) IBInspectable NSInteger maxNumberOfWords;//字符数限制
@property (nonatomic, strong) IBInspectable NSString *bat_placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, assign) IBInspectable BOOL numberOfWordsLabelHidden;
@property (nonatomic, copy) void (^textChangeBlock)(NSString *text);

+ (UIColor *)defaultPlaceholderColor;
@end
