//
//  BATHealthCircleTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthCircleImageCollectionView.h"
#import "BATHealthCircleCommentTableView.h"
#import "BATHotTopicModel.h"
#import "TrianglePathView.h"
#import "YYText.h"
/**
 *  头像点击
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^AvatarAction)(NSIndexPath *indexPath);

/**
 *  更多操作
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^MoreAction)(NSIndexPath *indexPath);

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
typedef void(^ThumbsUpAction)(NSIndexPath *indexPath);

/**
 *  长按删除评论回调
 *
 *  @param commentIndexPath 指定的评论行
 *  @param comment          评论数据
 */
typedef void(^LongTapCommentAction)(NSIndexPath *commentIndexPath,BATComments *comment);

/**
 *  点击评论中的人名
 *
 *  @param commentIndexPath 指定的评论行
 *  @param comment          评论数据
 */
typedef void(^CommentTapUserAction)(NSIndexPath *commentIndexPath,BATComments *comment);

/**
 *  音频回复按钮回调Block
 *
 *  @param indexPath 指定indexPath
 */
typedef void(^AudioReplyBlock)();

/**
 *  给评论的人回复
 *
 *  @param commentIndexPath 指定的评论行
 *  @param comment          评论数据
 */
typedef void(^CommentReplyAction)(NSIndexPath *commentIndexPath,BATComments *comment);

///**
// *  图片点击
// *
// *  @param index 图片tag
// */
//typedef void(^CollectionImageClickAction)(NSInteger index);

@interface BATTopicTableViewCell : UITableViewCell

/**
 *  Cell indexPath
 */
@property (strong, nonatomic) NSIndexPath *indexPath;

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

/**
 *  主标题
 */
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;

/**
 *  更多操作
 */
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;


/**
 *  发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *  点赞
 */
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;

/**
 *  性别图标
 */
@property (nonatomic,strong) UIImageView *sexView;

/**
 *  热门帖子图标
 */
@property (nonatomic,strong) UIImageView *hotView;

/**
 *  评论
 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/**
 *  回复按钮
 */
@property (strong, nonatomic)  UIButton *replyBtn;

/**
 *  图片collectionView
 */
@property (weak, nonatomic) IBOutlet BATHealthCircleImageCollectionView *collectionImageView;



/**
 *  音频回复按钮回调
 */
@property (strong, nonatomic) AudioReplyBlock audioAction;

/**
 *  头像点击回调
 */
@property (strong, nonatomic) AvatarAction avatarAction;


/**
 *  更多操作点击回调
 */
@property (strong, nonatomic) MoreAction moreAction;

/**
 *  评论按钮点击回调
 */
@property (strong, nonatomic) CommentAction commentAction;

/**
 *  点赞点击回调
 */
@property (strong, nonatomic) ThumbsUpAction thumbsUpAction;

/**
 *  长按删除评论回调
 */
@property (strong, nonatomic) LongTapCommentAction longTapCommentAction;

/**
 *  点击评论中的人名回调
 */
@property (strong, nonatomic) CommentTapUserAction commentTapUserAction;

/**
 *  给评论的人回复回调
 */
@property (strong, nonatomic) CommentReplyAction commentReplyAction;

///**
// *  图片点击
// */
//@property (strong, nonatomic) CollectionImageClickAction collectionImageClickAction;


/**
 *  配置数据
 *
 *  @param model 数据model
 */
- (void)configrationCell:(HotTopicData *)model;

@end
