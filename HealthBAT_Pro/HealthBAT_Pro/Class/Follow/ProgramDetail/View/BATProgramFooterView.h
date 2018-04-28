//
//  BATProgramFooterView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"
typedef void(^TestAction)(void);
@interface BATProgramFooterView : UIView

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 内容
 */
@property (nonatomic,strong) UILabel *contentLabel;

/**
 测试按钮
 */
@property (nonatomic,strong) BATGraditorButton *testButton;

/**
 测试Block
 */
@property (nonatomic,strong) TestAction testAction;

@end
