//
//  BATAddPicTableViewCell.h
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ItemWidth (SCREEN_WIDTH - 20 - 30) / 4.0f

@protocol BATAddPicTableViewCellDelegate <NSObject>

/**
 *  图片item点击回调
 *
 *  @param indexPath item的indexPath
 */
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath;

@end

@interface BATAddPicTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

/**
 *  图片collectionView
 */
@property (nonatomic,strong) UICollectionView *collectionView;

/**
 *  标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 *  描述
 */
@property (nonatomic,strong) UILabel *messageLabel;

/**
 *  委托
 */
@property (nonatomic,weak) id<BATAddPicTableViewCellDelegate> delegate;


/**
 *  重新加载collectionView
 *
 *  @param dataSource 图片数据
 */
- (void)reloadCollectionViewData:(NSMutableArray *)dataSource;

@end
