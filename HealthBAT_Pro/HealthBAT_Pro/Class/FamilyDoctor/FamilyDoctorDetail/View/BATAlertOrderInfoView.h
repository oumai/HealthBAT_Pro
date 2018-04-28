//
//  BATAlertOrderInfoView.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATFamilyDoctorModel.h"

@interface BATAlertOrderInfoView : UIView

@property (nonatomic,strong) UIView *bigBGView;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UITextField *buyerTextfiled;

@property (nonatomic,strong) UITextField *phoneTextfiled;

@property (nonatomic,strong) UITextField *adressTextfiled;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIView *buyerLine;

@property (nonatomic,strong) UIView *phoneLine;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,copy)   void(^sureButtonBlock)(void);

@property (nonatomic,copy)   void(^clickBigBGViewBlock)(void);

- (void)loadFamilyDoctorDetail:(BATFamilyDoctorModel *)familyDoctorDetail;

@end
