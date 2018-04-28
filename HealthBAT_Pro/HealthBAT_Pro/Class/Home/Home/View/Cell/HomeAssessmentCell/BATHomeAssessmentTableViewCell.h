//
//  AssessmentCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeAssessmentTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *assessmentCollectionView;
@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,copy) void(^assessmentClick)(NSIndexPath *clickedIndexPath);

@end
