//
//  BATHealthCircleCommentTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "BATMomentsModel.h"

/**
 *  点击评论中的UserName
 */
typedef void(^ClickUser)(id);

@interface BATHealthCircleCommentTableViewCell : UITableViewCell

/**
 *  指定行
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  评论
 */
@property (weak, nonatomic) IBOutlet YYLabel *commentLabel;

/**
 *  点击评论中的UserName
 */
@property (nonatomic, strong) ClickUser clickUser;

/**
 *  加载数据
 *
 *  @param model 数据
 */
- (void)confirgationCell:(BATComments *)model;

@end
