//
//  BATMessageCell.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATMessageCell : UITableViewCell

@property (nonatomic,strong) UIImageView    *iconImageV;
@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *descLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UILabel        *unreadLabel;

@end
