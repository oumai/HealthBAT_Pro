//
//  BATDrKangDiseaseView.h
//  HealthBAT_Pro
//
//  Created by KM on 17/7/182017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDrKangDiseaseView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *topButton;
@property (nonatomic,copy) void(^topBlock)(void);

@property (nonatomic,strong) UIButton *downButton;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,copy) void(^downBlock)(void);

@property (nonatomic,copy) void(^selectedDisease)(NSString *disease);

@property (nonatomic,strong) UICollectionView *diseaseCollectionView;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSArray *titleArray;

@end
