//
//  BATTeacherVideoCell.h
//  HealthBAT_Pro
//
//  Created by four on 16/12/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTeacherVideoCell : UITableViewCell

@property (nonatomic,strong) UILabel        *dateLabel;
@property (nonatomic,strong) UIImageView    *doctorImageV;
@property (nonatomic,strong) UIView         *blackBGView;
@property (nonatomic,strong) UILabel        *titleLabel;

@property (nonatomic,strong) UIImageView    *videoImageV;
@property (nonatomic,strong) UIImageView    *videoIcon;
@property (nonatomic,strong) UILabel        *subTitleLabel;
@property (nonatomic,strong) UILabel        *nameLabel;

@end
