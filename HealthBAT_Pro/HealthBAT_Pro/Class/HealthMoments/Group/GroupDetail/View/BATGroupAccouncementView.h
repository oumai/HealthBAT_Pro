//
//  BATGroupAccouncementView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGroupAccouncementModel.h"

@class BATGroupAccouncementView;
@protocol BATGroupAccouncementViewDelegate <NSObject>

- (void)groupAccouncementViewClicked:(BATGroupAccouncementView *)groupAccouncementView;

@end

@interface BATGroupAccouncementView : UIView

/**
 *  公告内容
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATGroupAccouncementViewDelegate> delegate;

/**
 *  加载数据
 *
 *  @param model 公告model
 */
- (void)configrationData:(BATGroupAccouncementModel *)model;

@end
