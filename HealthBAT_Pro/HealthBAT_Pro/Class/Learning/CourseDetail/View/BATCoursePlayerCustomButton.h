//
//  BATCoursePlayerCustomButton.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoursePlayerCustomButtonAction)(void);

@interface BATCoursePlayerCustomButton : UIView

/**
 图标
 */
@property (nonatomic,strong) UIImageView *imageView;

/**
 标题
 */
@property (nonatomic,strong) UILabel  *titleLabel;

/**
 按钮
 */
@property (nonatomic,strong) UIButton *button;

/**
 按钮Block
 */
@property (nonatomic,strong) CoursePlayerCustomButtonAction coursePlayerCustomButtonAction;

@end
