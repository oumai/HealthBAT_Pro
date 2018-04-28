//
//  HospitalCollectionViewCell.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHospitalCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * hospitalImageView;
@property (nonatomic,strong) UILabel * propertyLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * phoneLabel;

@property (nonatomic,strong) UILabel * titlePropertyLabel;
@property (nonatomic,strong) UILabel * titleAddressLabel;
@property (nonatomic,strong) UILabel * titlePhoneLabel;

@end
