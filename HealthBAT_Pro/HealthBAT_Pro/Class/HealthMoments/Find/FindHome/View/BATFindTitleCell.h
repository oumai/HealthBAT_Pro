//
//  BATFindTitleCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFindTitleCell : UITableViewCell

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  更多
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

/**
 *  accessory
 */
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageView;

@end
