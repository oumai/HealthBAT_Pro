//
//  BATConsultionHomeNewTopView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultionHomeNewTopView : UIView

@property (nonatomic,strong) UIView *bgview;

@property (nonatomic,strong) UIImageView *doctorImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *descLabel;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *pushImageView;

@property (nonatomic,copy) void(^PushTopViewBlock)(void);

//只有下拉，没有点击
//@property (nonatomic,copy) void(^PushSearchDoctorBlock)(void);

@end
