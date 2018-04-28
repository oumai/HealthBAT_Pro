//
//  UITextView+InputLimit.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (InputLimit)
@property (assign, nonatomic)  NSInteger maxLength;//if <=0, no limit
@end
