//
//  BATFindCommenCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFindCommenCell : UITableViewCell
@property (nonatomic,strong) UIView *bottomView;
/*
 * 图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
/*
 * 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabels;



@end
