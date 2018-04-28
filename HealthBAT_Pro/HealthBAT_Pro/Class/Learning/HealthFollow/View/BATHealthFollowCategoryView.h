//
//  BATHealthFollowCategoryView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSpecialtyTopicModel.h"
#import "BATGraditorButton.h"
typedef void(^CategoryButtonAction)(NSInteger index);

typedef void(^LoadCategoryFinish)(BOOL success);

@interface BATHealthFollowCategoryView : UIView

/**
 移动线条
 */
@property (nonatomic,strong) BATGraditorButton *blueLine;

/**
 分类按钮Block
 */
@property (nonatomic,strong) CategoryButtonAction categoryButtonAction;

/**
 加载分类完成
 */
@property (nonatomic,strong) LoadCategoryFinish loadCategoryFinish;

/**
 分类Model
 */
@property (nonatomic,strong) BATSpecialtyTopicModel *specialModel;

/**
 分类按钮数组
 */
@property (nonatomic,strong) NSMutableArray *buttons;

/**
 分类刷新状态数组
 */
@property (nonatomic,strong) NSMutableArray *refreshs;

/**
 请求分类
 */
- (void)requestAllCourseList;

/**
 分类动画

 @param index 分类index
 */
- (void)categoryAnimate:(NSInteger)index;

- (void)buttonAction:(UIButton *)button;

@end
