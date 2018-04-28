//
//  BATAlbumDetailCommentCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYText.h"
#import "BATAlbumDetailCommentModel.h"

/**
 *  点击评论中的UserName
 */
typedef void(^ClickUser)(void);

@interface BATAlbumDetailCommentCell : UITableViewCell

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
- (void)confirgationCell:(BATAlbumDetailCommentData *)model;

@end
