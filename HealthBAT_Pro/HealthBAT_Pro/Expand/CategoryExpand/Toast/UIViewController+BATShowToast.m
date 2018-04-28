//
//  UIViewController+BATShowToast.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UIViewController+BATShowToast.h"
#import "SVProgressHUD.h"

@implementation UIViewController (BATShowToast)

- (void)showProgress {
    
    [SVProgressHUD show];
    
//         [SVProgressHUD showImage:[UIImage animatedImageWithImages:@[[UIImage imageNamed:@"图层1"],[UIImage imageNamed:@"图层2"],[UIImage imageNamed:@"图层3"],[UIImage imageNamed:@"图层4"],[UIImage imageNamed:@"图层5"],[UIImage imageNamed:@"图层6"],[UIImage imageNamed:@"图层7"],[UIImage imageNamed:@"图层8"],[UIImage imageNamed:@"图层9"],[UIImage imageNamed:@"图层10"],[UIImage imageNamed:@"图层11"],[UIImage imageNamed:@"图层12"],[UIImage imageNamed:@"图层13"],[UIImage imageNamed:@"图层14"],[UIImage imageNamed:@"图层15"],[UIImage imageNamed:@"图层16"],[UIImage imageNamed:@"图层17"],[UIImage imageNamed:@"图层18"],[UIImage imageNamed:@"图层19"],[UIImage imageNamed:@"图层20"]] duration:1.5] status:nil];
}

- (void)showProgres:(float)progress {
    [SVProgressHUD showProgress:progress];
}

- (void)dismissProgress {
    [SVProgressHUD dismiss];

}

- (void)showText:(NSString *)text {
    [SVProgressHUD showImage:nil status:text];
}

- (void)showSuccessWithText:(NSString *)text {
    [SVProgressHUD showSuccessWithStatus:text];
}

- (void)showErrorWithText:(NSString *)text {
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showProgressWithText:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

- (void)showSuccessWithText:(NSString *)text completion:(void (^)(void))completion {
    
    [SVProgressHUD showSuccessWithStatus:text];
    NSTimeInterval time = [SVProgressHUD displayDurationForString:text];
    [self bk_performBlock:^(id obj) {
        if (completion) {
            completion();
        }
    } afterDelay:time];
    
}

- (void)showErrorWithText:(NSString *)text completion:(void (^)(void))completion {
    
    [SVProgressHUD showErrorWithStatus:text];
    NSTimeInterval time = [SVProgressHUD displayDurationForString:text];
    [self bk_performBlock:^(id obj) {
        if (completion) {
            completion();
        }
    } afterDelay:time];
}

- (void)showText:(NSString *)text withInterval:(NSTimeInterval)interval {
    [SVProgressHUD setMinimumDismissTimeInterval:interval];
    [self showText:text];
}

@end
