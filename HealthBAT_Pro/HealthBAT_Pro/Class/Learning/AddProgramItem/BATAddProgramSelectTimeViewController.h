//
//  BATAddProgramSelectTimeViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAddProgramSelectTimeView.h"

typedef void(^SaveTime)(NSString *time);

@interface BATAddProgramSelectTimeViewController : UIViewController

@property (nonatomic,strong) BATAddProgramSelectTimeView *selectTimeView;

@property (nonatomic,strong) SaveTime saveTime;

@end
