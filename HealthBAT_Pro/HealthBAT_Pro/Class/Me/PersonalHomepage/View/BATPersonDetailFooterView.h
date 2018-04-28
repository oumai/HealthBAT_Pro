//
//  BATPersonDetailFooterView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATPersonDetailFooterViewDelegate <NSObject>
/** 关注按钮点击调用 */
- (void)focusButtonDidClick:(UIButton *)focusBtn;
/** 私聊按钮点击调用 */
- (void)chatButtonDidClick:(UIButton *)chatBtn;

@end

@interface BATPersonDetailFooterView : UIView
/** 关注按钮 */
@property(nonatomic, strong)UIButton *focusButton;

/** delegate属性 */
@property (nonatomic, weak) id  <BATPersonDetailFooterViewDelegate>delegate;
@end
