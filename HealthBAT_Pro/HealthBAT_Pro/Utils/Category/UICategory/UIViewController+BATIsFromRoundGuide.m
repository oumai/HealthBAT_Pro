//
//  UIViewController+BATIsFromRoundGuide.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "UIViewController+BATIsFromRoundGuide.h"
#import <objc/runtime.h>

static const void *key = &key;

@implementation UIViewController (BATIsFromRoundGuide)

- (BOOL)isFromRoundGuide
{
    return [objc_getAssociatedObject(self, key) boolValue];
}

- (void)setIsFromRoundGuide:(BOOL)isFromRoundGuide
{
    objc_setAssociatedObject(self, key, @(isFromRoundGuide), OBJC_ASSOCIATION_ASSIGN);
}

@end
