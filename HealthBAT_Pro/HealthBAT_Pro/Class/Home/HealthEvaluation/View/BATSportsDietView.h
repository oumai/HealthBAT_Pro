//
//  BATSportsDietView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCustomCollectionView.h"
#import "BATHealthEvalutionModel.h"
@interface BATSportsDietView : UIView

@property (nonatomic,strong) BATCustomCollectionView *collectionView;

@property (nonatomic,strong) UIImageView *dietImageView;

@property (nonatomic,strong) UILabel *dietTitleLabel;

@property (nonatomic, strong) BATHealthEvalutionModel *model;

@property (nonatomic, copy) NSString *helpStrig;
@end
