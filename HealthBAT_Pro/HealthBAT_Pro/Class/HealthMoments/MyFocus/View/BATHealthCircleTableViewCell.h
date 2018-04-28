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
#import "BATMomentsModel.h"
#import "TrianglePathView.h"

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

@interface BATHealthCircleTableViewCell : UITableViewCell

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
 *  问题图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *problemImageView;

/**
 *  等级
 */
@property (weak, nonatomic) IBOutlet UIImageView *markView;

/**
 *  心情/个性签名
 */
@property (weak, nonatomic) IBOutlet UILabel *motoLabel;

/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

/**
 *  热门
 */
@property (weak, nonatomic) IBOutlet UIImageView *isHotBBS;

/**
 *  更多操作
 */
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 *  定位
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/**
 *  发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *  点赞
 */
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;

/**
 *  点赞数
 */
@property (weak, nonatomic) IBOutlet UILabel *thumbsUpCountLabel;

/**
 *  评论
 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/**
 *  图片collectionView
 */
@property (weak, nonatomic) IBOutlet BATHealthCircleImageCollectionView *collectionImageView;

/**
 *  评论小箭头
 */
@property (weak, nonatomic) IBOutlet TrianglePathView *trianglePathView;

/**
 *  评论tableView
 */
@property (weak, nonatomic) IBOutlet BATHealthCircleCommentTableView *commentTableView;

/**
 *  头像点击回调
 */
@property (strong, nonatomic) AvatarAction avatarAction;
/**
 *  评论label
 */
@property (weak, nonatomic) IBOutlet UILabel *desLB;

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
- (void)configrationCell:(BATMomentData *)model;

@end
