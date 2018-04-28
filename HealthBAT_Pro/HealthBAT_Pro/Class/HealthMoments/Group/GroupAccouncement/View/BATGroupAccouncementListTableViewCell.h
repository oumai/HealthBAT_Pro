//
//  BATGroupAccouncementListTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATGroupAccouncementListTableViewCell : UITableViewCell

/**
 *  背景
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 *  创建者
 */
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *  线
 */
@property (weak, nonatomic) IBOutlet UIView *line;

/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
