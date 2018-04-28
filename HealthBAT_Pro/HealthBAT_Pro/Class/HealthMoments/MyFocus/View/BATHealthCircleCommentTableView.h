//
//  BATHealthCircleCommentTableView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMomentsModel.h"

@class BATHealthCircleCommentTableView;
@protocol BATHealthCircleCommentTableViewDelegate <NSObject>

- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView clickedUser:(NSIndexPath *)indexPath comments:(BATComments *)comments;

- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView reply:(NSIndexPath *)indexPath comments:(BATComments *)comments;

- (void)commentTableView:(BATHealthCircleCommentTableView *)commentTableView delete:(NSIndexPath *)indexPath comments:(BATComments *)comments;

@end

@interface BATHealthCircleCommentTableView : UIView

/**
 *  评论列表
 */
@property (nonatomic,strong) UITableView *tableView;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATHealthCircleCommentTableViewDelegate> delegate;

/**
 *  加载评论数据
 *
 *  @param comments 评论数据
 */
- (void)loadCommentsData:(NSArray *)comments;

@end
