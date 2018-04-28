//
//  BATFreeClinicDoctorSubview.h
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

@interface BATFreeClinicDoctorSubview : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImageView *doctorIconView;

//@property (nonatomic,strong) UILabel *doctorNameLabel;
@property (nonatomic,strong) BATGraditorButton *doctorNameLabel;

@property (nonatomic,strong) UILabel *deptLabel;

@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end
