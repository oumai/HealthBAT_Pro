//
//  BATMemberCenterViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMemberCenterView.h"

@interface BATMemberCenterViewController : UIViewController

@property (nonatomic,strong) BATMemberCenterView *memberCenterView;

@property (nonatomic,assign) BOOL isFromNews;

@end
