//
//  BATDiteGuideDetailsViewController.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATDiteGuideDetailsViewController : UIViewController
- (instancetype)initWithDataID:(NSString *)dataID accountID:(NSInteger)accountID showDeleteBtn:(BOOL)show;
@end
