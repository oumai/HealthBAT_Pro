//
//  BATFamilyDoctorOrderDetailView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATFamilyDoctorOrderDetailNumberView.h"
#import "BATFamilyDoctorOrderInfoModel.h"

@interface BATFamilyDoctorOrderDetailView : UIView

@property (nonatomic,strong) BATFamilyDoctorOrderDetailNumberView *firstView;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailNumberView *secondView;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailNumberView *thirdView;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailNumberView *fourView;

@property (nonatomic,strong) BATFamilyDoctorOrderDetailNumberView *fiveView;

- (void)reloadViewWithData:(BATFamilyDoctorOrderState )OrderStateShow  isComment:(BOOL)isComment  IsOrder:(BOOL)IsOrder;

@end
