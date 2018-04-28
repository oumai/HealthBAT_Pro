//
//  BATGroupDynamicOperationView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATGroupDynamicOperationView;
@protocol BATGroupDynamicOperationViewDelegate <NSObject>

/**
 *  动态操作
 *
 *  @param groupDynamicOperationView groupDynamicOperationView
 *  @param type                      BATGroupDetailDynamicOpration
 */
- (void)groupDynamicOperationView:(BATGroupDynamicOperationView *)groupDynamicOperationView dynamicOprationClicked:(BATGroupDetailDynamicOpration)type;

@end

@interface BATGroupDynamicOperationView : UIView

/**
 *  全部
 */
@property (weak, nonatomic) IBOutlet UIButton *allButton;

/**
 *  问题
 */
@property (weak, nonatomic) IBOutlet UIButton *questionButton;

/**
 *  动态
 */
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;


/**
 *  滑块
 */
@property (weak, nonatomic) IBOutlet UIView *sliderLine;

/**
 *  委托
 */
@property (nonatomic, weak) id<BATGroupDynamicOperationViewDelegate> delegate;

@end
