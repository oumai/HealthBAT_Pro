//
//  BATCoursePlayerTestButton.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TestAction)(void);

@interface BATCoursePlayerTestButton : UIView

/**
 按钮
 */
@property (nonatomic,strong) UIButton *button;

/**
 按钮Block
 */
@property (nonatomic,strong) TestAction testAction;

@end
