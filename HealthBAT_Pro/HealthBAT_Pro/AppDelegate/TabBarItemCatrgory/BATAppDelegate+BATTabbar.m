//
//  BATAppDelegate+BATTabbar.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATTabbar.h"

#import "BATConsultationIndexViewController.h"

@implementation BATAppDelegate (BATTabbar)

- (void)setTarBarWithMessageCount:(BOOL)isShow{
    BATRootTabBarController *rootVC = (BATRootTabBarController *)self.window.rootViewController;
    
    if(isShow){
        [rootVC.tabBar showBadgeOnItemIndex:3];
    }else{
        [rootVC.tabBar hideBadgeOnItemIndex:3];
    }
}

@end
