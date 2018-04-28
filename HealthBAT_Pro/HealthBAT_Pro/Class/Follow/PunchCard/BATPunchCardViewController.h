//
//  BATPunchCardViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPunchCardView.h"

@interface BATPunchCardViewController : UIViewController

@property (nonatomic,strong) BATPunchCardView *punchCardView;

/**
 方案ID
 */
@property (nonatomic,assign) NSInteger templateID;

@end
