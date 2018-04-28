//
//  BATFamilyDoctorOrderInfoView.h
//  HealthBAT_Pro
//
//  Created by four on 17/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATFamilyDoctorOrderDetailModel.h"

@interface BATFamilyDoctorOrderInfoView : UIView

@property (nonatomic,strong) UILabel *buyerLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UILabel *serviceTypeLable;

@property (nonatomic,strong) UILabel *serviceTimeLabel;

@property (nonatomic,strong) UILabel *serviceCostLabel;

@property (nonatomic,strong) UIView *line;

- (void)loadFamilyDoctorOrderDetail:(BATFamilyDoctorOrderDetailModel *)orderModel;

@end
