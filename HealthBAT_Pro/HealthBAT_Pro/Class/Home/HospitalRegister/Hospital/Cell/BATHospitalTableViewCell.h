//
//  HospitalTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHospitalTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *hospitalImageView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *descriptionLabel;
@property (nonatomic,strong) UILabel     *registerTimesLabel;

@end
