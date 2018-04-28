//
//  UIAlertController+BATSupportedInterfaceOrientations.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "UIAlertController+BATSupportedInterfaceOrientations.h"

@implementation UIAlertController (BATSupportedInterfaceOrientations)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations; {
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

@end
