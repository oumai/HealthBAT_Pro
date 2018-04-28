//
//  BATConsultationActionTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/82016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultationActionTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *numberTitleLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UIButton *consulteButton;

@property (nonatomic,copy) void(^consultBlock)(void);

@end
