//
//  BATHomeDoctorHorderTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeDoctorHorderTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UICollectionView *doctorHorderCollectionView;
@property (nonatomic,copy) NSArray *dataArray;
@property (nonatomic,copy) NSArray *desArray;
@property (nonatomic,copy) NSArray *imageArray;
@property (nonatomic,copy) void(^doctorHorderClick)(NSIndexPath *clickedIndexPath);

@property (nonatomic,strong) UITableView *hotNoteTableView;
@property (nonatomic,copy) NSArray *hotNoteArray;
@property (nonatomic,copy) void(^hotNoteClick)(NSIndexPath *clickedIndexPath);

@end
