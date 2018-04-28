//
//  BATNearFamilyDoctorListView.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATNearFamilyDoctorListView : UIView

@property (nonatomic,strong) UIView *bigBGView;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *nearIconView;

@property (nonatomic,strong) UILabel *nearLable;

@property (nonatomic,strong) UILabel *numberLable;

@property (nonatomic,strong) UILabel *doctorLable;

@property (nonatomic,copy)   void(^reloadSearchBlock)(void);

@property (nonatomic,copy)   void(^pushNearFamilyDoctorListBlock)(void);

@end
