//
//  BATSegmentControl.h
//  Demo999
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 wangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATSegmentControl;

@interface BATSegmentButton : UIButton
//设置字体颜色
@property (nonatomic,strong) UIColor *titleColor;
//是否需要镂空
@property(nonatomic,assign) BOOL enablehollowOut;
//是否需要渐变层
@property(nonatomic,assign) BOOL enbleGraditor;

- (void)setGradientColors:(NSArray<UIColor *> *)colors;

@end
@protocol BATSegmentControlDelegate <NSObject>

- (void)batSegmentedControl:(BATSegmentControl *)segmentedControl selectedIndex:(NSInteger)index;
@end

@interface BATSegmentControl : UIView

@property (nonatomic ,strong) UIColor *segementBgColor;
@property (nonatomic ,strong) UIColor *segementSelTitleColor;
@property (nonatomic ,strong) UIColor *segementNorTitleColor;
@property (nonatomic ,assign) CGFloat textFont;
/**
 *  初始化对象方法
 *
 *  @param items 传入一个字符串数组
 *
 *  @return 实例对象
 */
- (instancetype)initWithItems:(NSArray *)items;


/**
 *  初始化类方法
 *
 *  @param items 传入一个字符串数组
 *
 *  @return 实例对象
 */
+ (instancetype)segmentedControlWithItems:(NSArray *)items;

/**
 *  根据外部关联scrollView的ContentSize和contoffSize,调整内部scrollView的偏移
 *
 *  @param contentSize    关联ScrollView的contentSize
 *  @param contentoffSize 关联ScrollView的contentoffSize
 */
/**
 *  当前选中索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger preSelctedIndex;
/**
 *  标题
 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<BATSegmentControlDelegate>delegate;


@property (nonatomic, assign) CGFloat segHeight;

@end
