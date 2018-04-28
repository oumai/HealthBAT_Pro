//
//  BATNewPayDoctorScheduleView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATNewDoctorScheduleModel.h"

@interface BATNewPayDoctorScheduleView : UIView


@property (nonatomic,strong) UIView  *blackBGView;

@property (nonatomic,strong) UIView *whiteBGView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) void(^blackViewClick)(void);

@property (nonatomic,copy) void(^chooseScheduleClick)(NSInteger Day,NSInteger row);

@property (nonatomic,copy) void(^noScheduleCanChooseClick)(void);

- (void)configrationData:(BATNewDoctorScheduleModel *)newDoctorScheduleModel;

@end
