//
//  BATTrainStudioCommentCell.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATTrainStudioCommentModel.h"

/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^headimgTapBlock)(NSIndexPath *indexPath);

@interface BATTrainStudioCommentCell : UITableViewCell

/**
 *  Cell indexPath
 */
@property (strong, nonatomic) NSIndexPath *indexPath;

/**
 头像
 */
@property (nonatomic,strong) UIImageView *headImageView;

/**
 用户名
 */
@property (nonatomic,strong) UILabel *nameLabel;

/**
 内容
 */
@property (nonatomic,strong) UILabel *contentLabel;

/**
 时间
 */
@property (nonatomic,strong) UILabel *timeLabel;


/**
 *  头像点击回调
 */
@property (strong, nonatomic) headimgTapBlock headimgTapBlocks;

- (void)configData:(BATTrainStudioCourseCommentData *)courseCommentData;

@end

