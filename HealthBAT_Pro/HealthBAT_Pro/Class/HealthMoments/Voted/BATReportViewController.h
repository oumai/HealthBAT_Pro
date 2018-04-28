//
//  BATReportViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/2.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATReportView.h"

@interface BATReportViewController : UIViewController

@property (nonatomic,strong) BATReportView *reportView;

@property (nonatomic,assign) NSInteger bizRecordID __deprecated_msg("已废弃，改用postId");

@property (nonatomic,copy) NSString *postId;

@end
