//
//  BATCustomScrollView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCustomScrollView.h"

@implementation BATCustomScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}


@end
