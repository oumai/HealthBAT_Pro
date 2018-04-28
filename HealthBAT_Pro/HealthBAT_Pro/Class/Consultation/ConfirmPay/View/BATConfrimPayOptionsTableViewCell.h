//
//  BATConfrimPayOptionsTableViewCell.h
//  HealthBAT
//
//  Created by jlteams on 16/8/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConfrimPayOptionsTableViewCell : UITableViewCell

/**
 *  支付选项图片
 */
@property (nonatomic,strong) UIImageView *optionsImageView;

/**
 *  支付选项名称
 */
@property (nonatomic,strong) UILabel *optionsTitleLabel;

/**
 *  选择支付方式ImageView
 */
@property (nonatomic,strong) UIImageView *selectImageView;

/**
 *  线
 */
@property (nonatomic,strong) UILabel *line;

@end
