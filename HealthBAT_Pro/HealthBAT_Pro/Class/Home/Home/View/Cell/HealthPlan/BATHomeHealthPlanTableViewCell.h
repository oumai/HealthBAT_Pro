//
//  BATHomeHealthPlanTableViewCell.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeHealthPlanTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *healthPlanCollectionView;

@property (nonatomic,copy) void(^healthPlanClick)(NSIndexPath *selectIndex);

@end
