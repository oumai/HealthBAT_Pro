//
//  BATHomeDoctorTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeDoctorTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *doctorCollectionView;
@property (nonatomic,copy) NSArray *dataArray;
@property (nonatomic,copy) NSArray *imageArray;

@property (nonatomic,copy) void(^doctorClick)(NSIndexPath *clickedIndexPath);

@end
