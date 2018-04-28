//
//  BATConsultationDepartmentDoctorTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultationDepartmentDoctorTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UIImageView *hospitalLevelImageView;
@property (nonatomic,strong) UIImageView *onlineStationImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *departmentLabel;
@property (nonatomic,strong) UILabel *descriptionLabel;

@end
