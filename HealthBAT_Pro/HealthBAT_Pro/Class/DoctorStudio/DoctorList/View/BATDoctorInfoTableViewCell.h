//
//  BATDoctorInfoTableViewCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *doctorNameLabel;

@property (nonatomic,strong) UILabel *hospitalLabel;

@property (nonatomic,strong) UILabel *departmentAndGoodAtLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *priceCountLabel;

@property (nonatomic,strong) UILabel *line;

@end
