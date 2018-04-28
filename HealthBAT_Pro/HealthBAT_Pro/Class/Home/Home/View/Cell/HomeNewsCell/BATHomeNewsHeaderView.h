//
//  BATHomeNewsHeaderView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeNewsHeaderView : UIView

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *hotNewsView;
@property (nonatomic,strong) UIButton *recommendNewsView;
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIButton *lastButton;

@property (nonatomic,copy) void(^categoryClickedBlock)(HomeNewsType type);


/**
 点击类别

 @param sender 点击的类别
 */
- (void)categoryTapped:(UIButton *)sender;

/**
 点击类别只执行逻辑

 @param sender 点击的类别
 */
- (void)categoryLogic:(UIButton *)sender;

/**
 点击类别只执行动画

 @param sender 点击的类别
 */
- (void)categoryButtonAnimate:(UIButton *)sender;

@end
