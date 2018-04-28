//
//  BATAlbumDetailReplyTableView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATAlbumDetailCommentModel.h"

typedef void(^ReplyCommentAction)(NSIndexPath *commentIndexPath,BATAlbumDetailCommentData *comment,NSInteger parentLevelId);

@interface BATAlbumDetailReplyTableView : UIView

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
