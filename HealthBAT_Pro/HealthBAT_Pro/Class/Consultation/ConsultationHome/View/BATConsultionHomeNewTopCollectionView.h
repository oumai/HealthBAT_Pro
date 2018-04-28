//
//  BATConsultionHomeNewCollectionView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATConsultionHomeNewTopCollectionView : UIView
//黑色背景
@property (nonatomic,strong) UIView *blackView;
//搜索框
@property (nonatomic,strong) UIView *searchBGview;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UIImageView *searchIcon;
//collectionView
@property (nonatomic,strong) UICollectionView *collectionView;
//向上箭头
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *pushImageView;

//@property (nonatomic,strong) NSArray *todayFreeClinicArray;
@property (nonatomic,strong) NSArray *deptArray;

@property (nonatomic,copy)  void(^clickBeginEditingBolok)(void);
@property (nonatomic,copy) void(^deptClickBlock)(NSIndexPath *clickedIndexPath);
@property (nonatomic,copy)  void(^clickHiddenCollectionViewBolok)(void);

- (void)remakelayouts;

@end

