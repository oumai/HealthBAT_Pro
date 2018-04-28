//
//  BATFamilyDoctorServiceTypeCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATFamilyDoctorModel.h"


@interface BATFamilyDoctorServiceTypeCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *textButton;
@property (nonatomic,strong) UIButton *audioButton;
@property (nonatomic,strong) UIButton *videoButton;
@property (nonatomic,strong) UIButton *goHomeButton;

- (void)setCellWithModel:(BATFamilyDoctorModel *)familyDoctorModel;

@end
