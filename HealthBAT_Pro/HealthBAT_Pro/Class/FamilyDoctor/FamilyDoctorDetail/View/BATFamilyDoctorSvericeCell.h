//
//  BATFamilyDoctorSvericeCell.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

#import "BATFamilyDoctorModel.h"

@interface BATFamilyDoctorSvericeCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UIButton *oneMothButton;
@property (nonatomic,strong) UIButton *threeMothButton;
@property (nonatomic,strong) UIButton *sixMothButton;
@property (nonatomic,strong) UIButton *twelveMothButton;

//设置新的四个按钮进行遮盖
@property (nonatomic,strong) BATGraditorButton *oneMButton;
@property (nonatomic,strong) BATGraditorButton *threeMButton;
@property (nonatomic,strong) BATGraditorButton *sixMButton;
@property (nonatomic,strong) BATGraditorButton *twelveMButton;

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *dateBGmView;
@property (nonatomic,strong) UIView *bottoBGmView;

@property (nonatomic,copy) void(^oneMothSeviceBlock)(void);
@property (nonatomic,copy) void(^threeMothSeviceBlock)(void);
@property (nonatomic,copy) void(^sixMothSeviceBlock)(void);
@property (nonatomic,copy) void(^twelveMothSeviceBlock)(void);

- (void)setCellWithModel:(BATFamilyDoctorModel *)familyDoctorModel;

@end
