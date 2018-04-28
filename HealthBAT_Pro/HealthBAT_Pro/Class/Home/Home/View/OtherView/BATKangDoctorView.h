//
//  BATKangDoctorView.h
//  HealthBAT_Pro
//
//  Created by KM on 16/12/262016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATKangDoctorView : UIView

@property (nonatomic,strong) UIImageView *kangDoctorImageView;
@property (nonatomic,copy) void(^tapped)(void);

@end
