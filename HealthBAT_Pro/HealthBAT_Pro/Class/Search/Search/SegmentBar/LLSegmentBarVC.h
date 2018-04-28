//
//  LLSegmentBarVC.h
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSegmentBar.h"

@protocol LLSegmentBarVCDelegate <NSObject>

/**
 通知外界内部的点击数据
 
 @param segmentBar segmentBar
 @param toIndex 选中的索引从0 开始
 @param fromIndex 上一个索引
 */
- (void)LLSegmentBarVC:(LLSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end

@interface LLSegmentBarVC : UIViewController

- (void)showChildVCViewAtIndex:(NSInteger)index;

@property (nonatomic,weak) id<LLSegmentBarVCDelegate> delegate;

@property (nonatomic,weak) LLSegmentBar * segmentBar;

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;

@end
