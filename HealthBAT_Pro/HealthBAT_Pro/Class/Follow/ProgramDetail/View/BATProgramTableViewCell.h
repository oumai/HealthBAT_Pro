//
//  BATProgramTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATProgramTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 时间
 */
@property (nonatomic,strong) BATGraditorButton *timeLabel;

/**
 剪头
 */
@property (nonatomic,strong) UIImageView *arrowImageView;

/**
 分割线
 */
@property (nonatomic,strong) UIView *lineView;

@end
