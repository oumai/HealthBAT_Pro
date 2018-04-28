//
//  BATCourseReplyCommentCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "BATTopicRecordModel.h"

/**
 *  点击评论中的UserName
 */
typedef void(^ClickUser)();

@interface BATTopicReplyCellTableViewCell : UITableViewCell

/**
 *  指定行
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  评论
 */
@property (strong, nonatomic) YYLabel *commentLabel;

/**
 *  点击评论中的UserName
 */
@property (nonatomic, strong) ClickUser clickUser;

/**
 *  加载数据
 *
 *  @param model 数据
 */
- (void)confirgationCell:(secondReplyData *)model;

@end
