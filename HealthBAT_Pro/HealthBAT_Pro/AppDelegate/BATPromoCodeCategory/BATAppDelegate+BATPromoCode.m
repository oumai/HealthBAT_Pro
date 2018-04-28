//
//  BATAppDelegate+BATPromoCode.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATPromoCode.h"
//#import "BATMyPromoCodeViewController.h"

@implementation BATAppDelegate (BATPromoCode)

- (void)bat_showPrompt{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"恭喜您-获得健康BAT免费健康咨询（图文咨询）一次" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * goOnAction = [UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
             BATRootTabBarController *rootVC = (BATRootTabBarController *)self.window.rootViewController;
             [rootVC setSelectedIndex:4];
            
//            BATMyPromoCodeViewController *promoCodeVC = [[BATMyPromoCodeViewController alloc]init];
//            promoCodeVC.hidesBottomBarWhenPushed = YES;
//            [[Tools getCurrentVC].navigationController pushViewController:promoCodeVC animated:YES];
        }];
        [alert addAction:okAction];
        [alert addAction:goOnAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
   
}



@end
