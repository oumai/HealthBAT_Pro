//
//  BATAlbumDetailOtherAlbumVideoCell.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BATAlbumDetailModel.h"

@interface BATAlbumDetailOtherAlbumVideoCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *videoCollectionView;

@property (nonatomic,strong) UIView  *lineView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *videoCountLabel;

@property (nonatomic,strong) NSArray *dataArray;


@property (nonatomic,copy) void(^videoClick)(NSIndexPath *clickedIndexPath);


- (void)sendAlbumVideoData:(BATAlbumDetailModel *)model;

@end
