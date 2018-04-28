//
//  BATProgramDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATProgramDetailView.h"

@interface BATProgramDetailViewController : UIViewController

@property (nonatomic,strong) BATProgramDetailView *programDetailView;

/**
 方案ID
 */
@property (nonatomic,assign) NSInteger templateID;

/**
 分数
 */
@property (nonatomic,assign) float persentage;

/**
 是否从测试进入
 */
@property (nonatomic,assign) BOOL isFromTest;

@end
