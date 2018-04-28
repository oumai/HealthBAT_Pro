//
//  BATDrugCollectionCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgramDetailModel.h"

@interface BATDrugCollectionCell : UICollectionViewCell

//图片
@property (nonatomic,strong) UIImageView *iconImageView;

//内容
@property (nonatomic,strong) UILabel *titleLb;

//销售价格
@property (nonatomic,strong) UILabel *salesLb;

//市场价格
@property (nonatomic,strong) UILabel *produtLb;

@property (nonatomic,strong) ProductList *model;

@end
