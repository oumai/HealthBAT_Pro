//
//  BATPersonDetailHeadView.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BATPersonDetailModel;

@protocol BATPersonDetailHeadViewDelegate <NSObject>

/** 粉丝数按钮点击调用 */
- (void)fansCountButtonDidClick:(UIButton *)fansBtn :(BATPersonDetailModel *)personModel;

/** 关注数按钮调用 */
- (void)focusCountButtonDidClick:(UIButton *)focusBtn;

/** 点击头像调用 */
- (void)focusHeaderViewDidClick;

@end

@interface BATPersonDetailHeadView : UIView
/** model */
@property (nonatomic ,strong) BATPersonDetailModel *personModel;
/** delegate属性 */
@property (nonatomic, weak) id  <BATPersonDetailHeadViewDelegate>delegate;
@end
