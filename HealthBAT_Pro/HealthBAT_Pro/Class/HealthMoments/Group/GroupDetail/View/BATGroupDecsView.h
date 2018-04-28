//
//  BATGroupDecsView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATGroupDecsView;
@protocol BATGroupDecsViewDelegate <NSObject>

/**
 *  加入群组
 *
 *  @param groupDecsView groupDecsView
 *  @param button        加入群组按钮
 */
- (void)groupDecsView:(BATGroupDecsView *)groupDecsView joinGroupButtonClicked:(UIButton *)button;


/**
 *  群组成员
 *
 *  @param groupDecsView groupDecsView
 *  @param button        群组成员按钮
 */
- (void)groupDecsView:(BATGroupDecsView *)groupDecsView groupMemberButtonClicked:(UIButton *)button;

@end

@interface BATGroupDecsView : UIView

/**
 *  群组ICON
 */
@property (weak, nonatomic) IBOutlet UIImageView *groupIconImageView;

/**
 *  群组名称
 */
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

/**
 *  群组描述
 */
@property (weak, nonatomic) IBOutlet UILabel *groupDescLabel;

/**
 *  群组成员按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *groupMemberButton;

/**
 *  加入群组
 */
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;

/**
 *  委托
 */
@property (nonatomic, weak) id<BATGroupDecsViewDelegate> delegate;

/**
 *  加载数据
 *
 *  @param model 群组详情model
 */
- (void)configrationData:(id)model;

@end
