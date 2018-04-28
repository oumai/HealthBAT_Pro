//
//  BATConsultationDoctorCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/8/252016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATConsultationDoctorModel.h"
#import "BATFreeClinicDoctorModel.h"

@interface BATConsultationDoctorCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *departNameLabel;
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,copy) void(^moreBlock)(void);
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UICollectionView *doctorCollectionView;
@property (nonatomic,copy) void(^doctorClick)(NSIndexPath *clickedIndexPath);
@property (nonatomic,copy) NSArray *dataArray;

- (void)sendDoctorData:(NSArray <ConsultationDoctors *>*)data;

- (void)sendFreeClinicDoctorData:(NSArray <FreeClinicDoctorData *>*)data;

@end
