//
//  BATDoctorStudioVideoListCell.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDoctorStudioVideoListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *statusImageView;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *serviceTypeLabel;
@property (nonatomic,strong) UILabel *serviceTimeLabel;
@property (nonatomic,strong) UIButton *consulationBtn;

@property (nonatomic,strong) UIView *separatorView;

@property (nonatomic,copy) void(^consultationBlock)(void);

@end
