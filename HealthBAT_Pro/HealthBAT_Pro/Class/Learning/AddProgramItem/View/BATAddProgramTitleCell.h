//
//  BATAddProgramTitleCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATAddProgramTitleCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 输入框
 */
@property (nonatomic,strong) UITextField *titleTextField;

/**
 剪头
 */
@property (nonatomic,strong) UIImageView *arrowImageView;

@end
