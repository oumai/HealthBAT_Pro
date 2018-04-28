//
//  BATDoctorStudioTextImageTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/4/122017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BATDoctorStudioTextImageTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *statusImageView;
@property (nonatomic,strong) UILabel *serviceDoctorLabel;
@property (nonatomic,strong) UILabel *serveTimeLabel;
@property (nonatomic,strong) UILabel *orderTimeLabel;
@property (nonatomic,strong) UIView *separatorView;
@property (nonatomic,strong) UIButton *actionButton;
@property (nonatomic,strong) UIButton *commentButton;

@property (nonatomic,copy) void(^actionBlock)(void);
@property (nonatomic,copy) void(^commentBlock)(void);

@end
