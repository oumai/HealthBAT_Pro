//
//  BATCourseReplyTableView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseCommentModel.h"

typedef void(^ReplyCommentAction)(NSIndexPath *commentIndexPath,BATCourseCommentData *comment,NSInteger parentLevelId);

@interface BATCourseReplyTableView : UIView

/**
 *  评论列表
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 评论层次
 */
@property (nonatomic,assign) NSInteger parentLevelId;

/**
 回复Block
 */
@property (nonatomic,strong) ReplyCommentAction replyCommentAction;

/**
 *  加载评论数据
 *
 *  @param comments 评论数据
 */
- (void)loadCommentsData:(NSArray *)comments;

@end
