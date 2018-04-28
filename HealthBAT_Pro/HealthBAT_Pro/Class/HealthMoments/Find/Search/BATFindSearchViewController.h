//
//  BATFindSearchViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATFindSearchView.h"

@interface BATFindSearchViewController : UIViewController

@property (nonatomic,strong) BATFindSearchView *findSearchView;

@property (nonatomic,assign) BATRecommendType recommendType;

@end
