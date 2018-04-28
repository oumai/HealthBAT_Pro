//
//  BATHealthThreeSecondsArrowCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondsArrowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, copy) void(^infoButtonBlock)();
@end
