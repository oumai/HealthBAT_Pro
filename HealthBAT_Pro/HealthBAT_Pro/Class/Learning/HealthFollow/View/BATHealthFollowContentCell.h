//
//  BATHealthFollowContentCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseModel.h"

@interface BATHealthFollowContentCell : UITableViewCell

@property (nonatomic,strong) UIImageView *thumbImageView;

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

- (void)confirgationCell:(BATCourseData *)data;

@end
