//
//  BATHomeOnlineStudyTableViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/12/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHomeOnlineStudyTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *studyCollectionView;

@property (nonatomic,copy) void(^studyClicked)(NSIndexPath *clickedIndexPath);

@end
