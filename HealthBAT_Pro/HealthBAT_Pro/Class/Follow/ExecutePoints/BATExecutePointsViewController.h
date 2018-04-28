//
//  BATExecutePointsViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATExecutePointsView.h"
#import "BATProgramDetailModel.h"

@interface BATExecutePointsViewController : UIViewController

@property (nonatomic,strong) BATExecutePointsView *executePointsView;

@property (nonatomic,strong) BATProgramDetailModel *programDetailModel;

@end
