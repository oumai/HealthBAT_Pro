//
//  BATTopicReplyTableView.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATTopicRecordModel.h"

typedef void(^TopicReplyCommentAction)(NSIndexPath *commentIndexPath,secondReplyData *comment,NSInteger parentLevelId);

@interface BATTopicReplyTableView : UIView

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
@property (nonatomic,strong) TopicReplyCommentAction topicreplyCommentAction;

/**
 *  加载评论数据
 *
 *  @param comments 评论数据
 */
- (void)loadCommentsData:(NSArray *)comments;

@end
