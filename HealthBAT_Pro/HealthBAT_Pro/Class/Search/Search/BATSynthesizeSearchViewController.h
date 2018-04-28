//
//  BATSynthesizeSearchViewController.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/9/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSearchResultModel.h"

@interface BATSynthesizeSearchViewController : UIViewController

@property (nonatomic,strong) BATSearchResultModel *searchResultModel;
@property (nonatomic,strong) UICollectionView *searchCollectionView;

@end
