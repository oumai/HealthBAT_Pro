//
//  BATFourthTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFourthTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *answerCollectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSIndexPath *tmpIndexPath;

@property (nonatomic,copy) void(^answerSelectedIndexPath)(NSIndexPath *indexPath);

@end
