//
//  BATHomeHealthStepTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeHealthStepTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *healthStepCollectionView;
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *imageArray;
@property (nonatomic,copy) NSArray *detailArray;

@end
