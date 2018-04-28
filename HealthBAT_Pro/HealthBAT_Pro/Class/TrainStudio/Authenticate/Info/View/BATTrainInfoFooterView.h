//
//  BATTrainInfoFooterView.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATTrainInfoFooterView : UIView
/**
 提交按钮
 */
@property (nonatomic,strong) BATGraditorButton *submitButton;

/**
 提交Block
 */
@property (nonatomic,copy) void(^submitBlock)(void);

@end
