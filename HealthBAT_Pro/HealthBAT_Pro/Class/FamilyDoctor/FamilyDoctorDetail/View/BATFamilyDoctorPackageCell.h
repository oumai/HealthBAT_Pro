//
//  BATFamilyDoctorPackageCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATGraditorButton.h"

#import "BATFamilyDoctorModel.h"

@interface BATFamilyDoctorPackageCell : UITableViewCell

@property (nonatomic,strong) UIView *topBGView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIView *topLine;

@property (nonatomic,strong) UIImageView *oneMothIcon;
@property (nonatomic,strong) UIImageView *threeMothIcon;
@property (nonatomic,strong) UIImageView *sixMothIcon;
@property (nonatomic,strong) UIImageView *twelveMothIcon;

@property (nonatomic,strong) UIImageView *oneMothBGView;
@property (nonatomic,strong) UIImageView *threeMothBGView;
@property (nonatomic,strong) UIImageView *sixMothBGView;
@property (nonatomic,strong) UIImageView *twelveMothBGView;

@property (nonatomic,strong) UIImageView *oneMothClickBGView;
@property (nonatomic,strong) UIImageView *threeMothClickBGView;
@property (nonatomic,strong) UIImageView *sixMothClickBGView;
@property (nonatomic,strong) UIImageView *twelveMothClickBGView;

@property (nonatomic,strong) BATGraditorButton *oneMButton;
@property (nonatomic,strong) BATGraditorButton *threeMButton;
@property (nonatomic,strong) BATGraditorButton *sixMButton;
@property (nonatomic,strong) BATGraditorButton *twelveMButton;

@property (nonatomic,strong) UIView *bottomBGView;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,copy) void(^oneMothSeviceBlock)(void);
@property (nonatomic,copy) void(^threeMothSeviceBlock)(void);
@property (nonatomic,copy) void(^sixMothSeviceBlock)(void);
@property (nonatomic,copy) void(^twelveMothSeviceBlock)(void);

- (void)setCellWithModel:(BATFamilyDoctorModel *)familyDoctorModel;

@end
