//
//  BATPunchCardTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATGraditorButton.h"

@interface BATPunchCardTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatorImageView;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) BATGraditorButton *titleLabel;

@property (nonatomic,strong) UILabel *dayLabel;


@end
