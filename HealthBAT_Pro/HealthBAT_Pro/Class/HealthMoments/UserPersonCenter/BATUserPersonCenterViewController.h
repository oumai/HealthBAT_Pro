//
//  BATUserPersonCenterViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATUserPersonCenterView.h"

@interface BATUserPersonCenterViewController : UIViewController

@property (nonatomic,strong) BATUserPersonCenterView *userPersonCenterView;

/**
 *  用户ID
 */
@property (nonatomic,assign) NSInteger AccountID;

/**
 *  用户类型
 */
@property (nonatomic,assign) NSInteger AccountType;

@end
