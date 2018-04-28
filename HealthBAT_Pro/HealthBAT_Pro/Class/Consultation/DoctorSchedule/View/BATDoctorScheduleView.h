//
//  BATDoctorScheduleView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorScheduleFooterView.h"
#import "BATDoctorScheduleModel.h"

typedef NS_ENUM(NSInteger,BATNextSevenType)
{
    BATNowSeven = 0,
    BATNextSeven = 1,
};

@interface BATDoctorScheduleView : UIView

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *contarinerView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) BATDoctorScheduleFooterView *footerView;

@property (nonatomic,assign) NSInteger selectScheduleIndex;

@property (nonatomic,assign) NSInteger selectRegnumlistIndex;

- (void)configrationData:(BATDoctorScheduleModel *)doctorScheduleModel;

@end
