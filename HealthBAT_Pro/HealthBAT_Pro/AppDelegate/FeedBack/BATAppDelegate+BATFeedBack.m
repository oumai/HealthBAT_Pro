//
//  BATAppDelegate+BATFeedBack.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAppDelegate+BATFeedBack.h"
#import "Aspects.h"
#import "BATOpinionViewController.h"

@implementation BATAppDelegate (BATFeedBack)

- (void)bat_feedBack {
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
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
        UIViewController * vc = aspectInfo.instance;
        
        UIButton *feedBackButton = (UIButton *)[self.window viewWithTag:9988];
        if (feedBackButton) {
            
            if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"BATOpinionViewController")] ||
                [aspectInfo.instance isKindOfClass:NSClassFromString(@"BATLoginViewController")] ||
                [aspectInfo.instance isKindOfClass:NSClassFromString(@"BATRegisterViewController")] ) {
                feedBackButton.hidden = YES;
                //意见反馈、登录、注册不显示按钮
                return;
            }
            [feedBackButton setTitle:[NSString stringWithFormat:@"%@_%@",vc.class,vc.title] forState:UIControlStateNormal];
            feedBackButton.hidden = NO;
            return;
        }
        
        
        feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        feedBackButton.hidden = NO;
        feedBackButton.tag = 9988;
        feedBackButton.backgroundColor = [UIColor clearColor];
        [feedBackButton setTitle:[NSString stringWithFormat:@"%@_%@",vc.class,vc.title] forState:UIControlStateNormal];
        [feedBackButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [feedBackButton setBackgroundImage:[UIImage imageNamed:@"home-feedback"] forState:UIControlStateNormal];
        [feedBackButton addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:feedBackButton];
        [self.window bringSubviewToFront:feedBackButton];
        
        [feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.window.mas_right).offset(-25);
            make.bottom.equalTo(self.window.mas_bottom).offset(-49-25);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [vc.view bringSubviewToFront:feedBackButton];
    } error:NULL];
}


- (void)feedBack:(UIButton *)sender {
    
    BATOpinionViewController * opinionVC = [BATOpinionViewController new];
    NSArray *tmpArray = [sender.titleLabel.text componentsSeparatedByString:@"_"];
    opinionVC.className = tmpArray[0];
    opinionVC.titleName = tmpArray[1];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:opinionVC];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    DDLogDebug(@"%@", sender.titleLabel.text);
}


@end
