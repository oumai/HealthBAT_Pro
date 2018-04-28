//
//  BATDoctorScheduleOptionCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDoctorScheduleModel.h"

@interface BATDoctorScheduleOptionCell : UICollectionViewCell

//@property (nonatomic,strong) UILabel *titleLabel;
//
//@property (nonatomic,strong) UIView *borderView;

@property (nonatomic,strong) Regnumlist *regNumList;

@property (nonatomic,strong) UIImageView *chooseImageView;
@property (nonatomic,strong) UIImageView *unChooseImageView;
@end
