//
//  BATSelectLocationViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATSelectLocationViewController : UIViewController

//传地理位置
@property (nonatomic,copy) void(^addressBlock)(NSString *);

@end
