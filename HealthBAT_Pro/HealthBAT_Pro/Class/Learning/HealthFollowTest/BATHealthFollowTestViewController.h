//
//  BATHealthFollowTestViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthFollowTestView.h"

@interface BATHealthFollowTestViewController : UIViewController

@property (nonatomic,strong) BATHealthFollowTestView *healthFollowTestView;

/**
 课程
 */
@property (nonatomic,assign) NSInteger courseID;

@end
