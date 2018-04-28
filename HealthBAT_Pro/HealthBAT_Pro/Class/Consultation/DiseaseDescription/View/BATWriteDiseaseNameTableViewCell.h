//
//  BATWriteDiseaseNameTableViewCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BATWriteDiseaseNameTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *diseaseNameCollectionView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,copy) void(^videoClick)(NSIndexPath *clickedIndexPath);


@end
