//
//  BATNavHomeViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATNavHomeView.h"
#import "BATRoundGuideViewController.h"
#import "BATHealthEvaluationViewController.h"


@interface BATNavHomeViewController : UIViewController

@property (nonatomic,strong) BATNavHomeView *navHomeView;

@property (nonatomic,strong) BATRoundGuideViewController *roundVC;

@property (nonatomic,strong) BATHealthEvaluationViewController *healthEvaluationVC;



@end
