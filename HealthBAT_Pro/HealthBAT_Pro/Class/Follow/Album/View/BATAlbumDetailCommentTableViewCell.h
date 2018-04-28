//
//  BATAlbumDetailCommentTableViewCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAlbumDetailCommentModel.h"
#import "BATCustomButton.h"
#import "TrianglePathView.h"
#import "BATAlbumDetailReplyTableView.h"
#import "BATTopicRecordModel.h"
#import "BATTopicReplyTableView.h"

/**
 *  评论按钮点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^CommentAction)(NSIndexPath *indexPath);

/**
 *  点赞
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^LikeAction)(NSIndexPath *indexPath);

/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^headimgTapBlock)(NSIndexPath *indexPath);

@interface BATAlbumDetailCommentTableViewCell : UITableViewCell

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
 点赞按钮
 */
@property (nonatomic,strong) UIButton *likeButton;

/**
 评论按钮
 */
@property (nonatomic,strong) UIButton *commnetButton;

/**
 点赞数
 */
@property (nonatomic,strong) UILabel *likeCountLabel;

/**
 评论数
 */
@property (nonatomic,strong) UILabel *commentCountLabel;

/**
 *  评论小箭头
 */
@property (nonatomic,strong) TrianglePathView *trianglePathView;

/**
 评论列表
 */
@property (nonatomic,strong) BATAlbumDetailReplyTableView *replyTableView;
/**
 Topic评论列表
 */
@property (nonatomic,strong) BATTopicReplyTableView *TopicreplyTableView;

/**
 *  评论按钮点击回调
 */
@property (strong, nonatomic) CommentAction commentAction;

/**
 *  透明点赞按钮
 */
@property (strong, nonatomic) UIButton *priseBtn;

/**
 *  透明评论按钮
 */
@property (strong, nonatomic) UIButton *commentBtn;

/**
 *  右上角投诉按钮
 */
@property (strong, nonatomic) BATCustomButton *rightUpBtn;


/**
 *  点赞点击回调
 */
@property (strong, nonatomic) LikeAction likeAction;

/**
 *  头像点击回调
 */
@property (strong, nonatomic) headimgTapBlock headimgTapBlocks;

- (void)configData:(BATAlbumDetailCommentData *)albumCommentData;

@end
