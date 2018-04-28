//
//  BATDrugOrderInfoView.h
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDrugOrderInfoView : UIView

//患者信息
@property (nonatomic,strong) UILabel *userMesTitleLabel;
//name、sex、birthday、phone
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *sexLabel;
@property (nonatomic,strong) UILabel *birthdayLabel;
@property (nonatomic,strong) UILabel *phoneLabel;

////诊断信息
//@property (nonatomic,strong) UILabel *consultMesTitleLabel;
////病症列表
//@property (nonatomic,strong) UILabel *symptomsLabel;
//
////RP
//@property (nonatomic,strong) UILabel *rpMesTitleLabel;
////RP列表
//@property (nonatomic,strong) UILabel *rpLabel;
//
////医生
//@property (nonatomic,strong) UILabel *doctorTitleLabel;
////医生信息
//@property (nonatomic,strong) UILabel *doctorInfoLabel;

- (void)contentViewReload;

@end
