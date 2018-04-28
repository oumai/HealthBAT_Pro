//
//  AppDelegate.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATRootTabBarController.h"//跟视图
#import "BATNavHomeViewController.h"

@interface BATAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) BATRootTabBarController *rootTabBarController;

@property (nonatomic,strong) UINavigationController *navHomeVC;

@end

