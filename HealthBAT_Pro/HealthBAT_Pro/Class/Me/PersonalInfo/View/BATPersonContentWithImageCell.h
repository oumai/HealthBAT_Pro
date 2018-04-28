//
//  BATPersonContentWithImageCell.h
//  HealthBAT_Pro
//
//  Created by four on 16/9/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPerson.h"
@interface BATPersonContentWithImageCell : UITableViewCell

/**
 *  icon
 */
@property (nonatomic, strong) UIImageView *iconImageV;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

- (void)loginAccountCell:(NSIndexPath *)indexPath Model:(BATPerson *)model;

@end
