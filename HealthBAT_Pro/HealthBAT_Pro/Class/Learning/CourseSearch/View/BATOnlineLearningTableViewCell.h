//
//  BATOnlineLearningTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseModel.h"

typedef void(^OnlineLearningCollectionBtnClick)(NSIndexPath *indexPath);

@interface BATOnlineLearningTableViewCell : UITableViewCell

/**
 图片
 */
@property (nonatomic,strong) UIImageView *contentImageView;

/**
 视频icon
 */
@property (nonatomic,strong) UIImageView *videoIconImageView;

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 作者
 */
@property (nonatomic,strong) UILabel *authorLabel;

/**
 学习人数
 */
@property (nonatomic,strong) UILabel *learningCountLabel;

/**
 浏览量icon
 */
@property (nonatomic,strong) UIButton *readImageBtn;

/**
 浏览量
 */
@property (nonatomic,strong) UILabel *readCountLabel;

/**
 评论icon
 */
@property (nonatomic,strong) UIButton *commentImageBtn;

/**
 评论数
 */
@property (nonatomic,strong) UILabel *commentCountLabel;

/**
 收藏icon
 */
@property (nonatomic,strong) UIButton *collectImageBtn;

/**
 收藏数
 */
@property (nonatomic,strong) UILabel *collectionCountLabel;

/**
 收藏Block
 */
@property (nonatomic,strong) OnlineLearningCollectionBtnClick onlineLearningCollectionBtnClick;

/**
 索引
 */
@property (nonatomic,strong) NSIndexPath *indexPath;

- (void)confirgationCell:(BATCourseData *)data;

@end
