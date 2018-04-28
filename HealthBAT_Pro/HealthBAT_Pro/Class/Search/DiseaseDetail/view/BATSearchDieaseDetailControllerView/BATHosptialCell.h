//
//  BATHosptialCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHosptialCell : UITableViewCell

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * hospitalImageView;
@property (nonatomic,strong) UILabel * propertyLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * phoneLabel;

@property (nonatomic,strong) UILabel * titlePropertyLabel;
@property (nonatomic,strong) UILabel * titleAddressLabel;
@property (nonatomic,strong) UILabel * titlePhoneLabel;

@end
