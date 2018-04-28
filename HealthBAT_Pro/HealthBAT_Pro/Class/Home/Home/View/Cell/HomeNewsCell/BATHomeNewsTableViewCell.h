//
//  BATHomeNewsCollectionViewCell.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/202016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHomeNewsHeaderView.h"

@interface BATHomeNewsTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) BATHomeNewsHeaderView *headerView;
@property (nonatomic,strong) UICollectionView      *newsCollectionView;
@property (nonatomic,assign) NSInteger             recommendCurrentPage;
@property (nonatomic,strong) NSMutableArray        *recommendNewsDataArray;
@property (nonatomic,assign) NSInteger             hotCurrentPage;
@property (nonatomic,strong) NSMutableArray        *hotNewsDataArray;

@property (nonatomic,copy) void(^newsClickedBlock)(NSString *newsID, NSString *newsTitle);
@property (nonatomic,copy) void(^categoryClick)(NSInteger tag);


@end
