//
//  BATDoctorFilterView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATFilterTypeView.h"
#import "BATDoctorFilterFooterView.h"

@interface BATDoctorFilterView : UIView

@property (nonatomic,strong) BATFilterTypeView *serviceView;

@property (nonatomic,strong) BATFilterTypeView *titleView;

@property (nonatomic,strong) NSMutableArray *service;

@property (nonatomic,strong) NSMutableArray *title;

@property (nonatomic,strong) BATDoctorFilterFooterView *footerView;

@end
