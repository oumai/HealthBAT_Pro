//
//  BATPersonContentCell.h
//  CancerNeighbour
//
//  Created by Wilson on 15/10/28.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPerson.h"

@interface BATPersonContentCell : UITableViewCell

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

- (void)configrationCell:(NSIndexPath *)indexPath Model:(BATPerson *)model;

@end
