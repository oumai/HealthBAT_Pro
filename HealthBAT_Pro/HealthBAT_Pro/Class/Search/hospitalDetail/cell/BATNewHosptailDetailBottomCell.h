//
//  BATNewHosptailDetailBottomCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATNewHosptailDetailBottomCell : UITableViewCell

@property (nonatomic,strong) UIImageView *doctorIcon;
@property (nonatomic,strong) UIImageView *hospitalIcon;

@property (nonatomic,strong) UILabel *docrotTitleLabel;
@property (nonatomic,strong) UILabel *hospitalTitleLabel;

@property (nonatomic,strong) UILabel *docrotDescLabel;
@property (nonatomic,strong) UILabel *hospitalDescLabel;

@property (nonatomic,strong) UIView *deptDoctorView;
@property (nonatomic,strong) UIView *hospitalDetailView;

@property (nonatomic,strong) void(^clickDeptDoctorBlock)(void);
@property (nonatomic,strong) void(^clickHospitalDetailBlock)(void);

@end
