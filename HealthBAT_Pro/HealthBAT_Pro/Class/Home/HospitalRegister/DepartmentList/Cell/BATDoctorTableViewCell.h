//
//  DoctorTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/152016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *descriptionLabel;

@property (nonatomic,strong) UIImageView *stateImageView;

@end
