//
//  BATAppDelegate+BATViewControllerSetting.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATViewControllerSetting.h"

#import "Aspects.h"
#import "TZImagePickerController.h"
#import "SVProgressHUD.h"

#import "BATWaitingRoomViewController.h"
#import "BATAppDelegate+AgoraCategory.h"

@implementation BATAppDelegate (BATViewControllerSetting)

- (void)bat_settingVC {
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UIViewController * vc = aspectInfo.instance;

        if (vc == nil) {
            return ;
        }

        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"_UIRemoteInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")]) {
            //屏蔽一些系统界面

            return ;
        }

        //背景色
        vc.view.backgroundColor = BASE_BACKGROUND_COLOR;
        
        //返回按钮
        if (vc.navigationController.viewControllers.count> 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 40, 40);
            WEAK_SELF(vc);
            [btn bk_whenTapped:^{
                STRONG_SELF(vc);
                [vc.navigationController popViewControllerAnimated:YES];
                [vc dismissViewControllerAnimated:YES completion:nil];
            }];
            [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            vc.navigationItem.leftBarButtonItem = backItem;
            
            vc.hidesBottomBarWhenPushed = YES;
        }
        
        //导航条标题
        [vc.navigationController.navigationBar setTitleTextAttributes:@{
                                                                        NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),
                                                                        NSFontAttributeName:stringFont(20)
                                                                        }];

        //导航条背景色
        [vc.navigationController.navigationBar setBackgroundImage:[Tools imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        vc.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:BASE_LINECOLOR];

        [vc.navigationController.navigationBar setTintColor:UIColorFromHEX(0x333333, 1)];
        
        
    } error:NULL];
}

- (void)bat_VCDissmiss {

    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {

        UIViewController * vc = aspectInfo.instance;
        if (vc == nil) {
            return ;
        }

        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")]) {
            //屏蔽一些系统界面

            return ;
        }

        [SVProgressHUD dismiss];
        [vc.view endEditing:YES];
        
        
        if ([vc isKindOfClass:[BATWaitingRoomViewController class]]) {
            
            [self bat_registerAgora];
        }
        
        
    } error:NULL];
}




@end
