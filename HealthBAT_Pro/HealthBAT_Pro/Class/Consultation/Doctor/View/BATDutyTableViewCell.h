//
//  DutyTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDutyTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel  *timeLabel;
@property (nonatomic,strong) UILabel  *countLabel;
@property (nonatomic,strong) UILabel  *priceLabel;
@property (nonatomic,strong) UIButton *registerButton;

@property (nonatomic,copy) void(^hospitalRegister)(void);

@end
