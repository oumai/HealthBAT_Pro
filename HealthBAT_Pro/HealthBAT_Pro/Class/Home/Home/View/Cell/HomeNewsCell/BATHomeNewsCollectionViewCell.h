//
//  BATHotNewsCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+EmptyDataSet.h"
#import "BATPassTableView.h"

@interface BATHomeNewsCollectionViewCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) BATPassTableView *newsListTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL canScroll;
@property (nonatomic,assign) float lastPositionY;

@property (nonatomic,copy) void(^newsClickedBlock)(NSString *newsID, NSString *newsTitle);


@end
