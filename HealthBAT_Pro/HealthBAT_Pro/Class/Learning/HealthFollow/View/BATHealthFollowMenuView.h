//
//  BATHealthFollowMenuView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionCellClicked)(NSIndexPath *indexPath);
@interface BATHealthFollowMenuView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) CollectionCellClicked collectionCellClicked;

@end
