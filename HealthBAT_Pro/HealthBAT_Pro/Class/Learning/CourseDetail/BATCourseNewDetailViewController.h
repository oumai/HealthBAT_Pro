//
//  BATCourseNewDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseNewDetailView.h"

@interface BATCourseNewDetailViewController : UIViewController

@property (nonatomic,strong) BATCourseNewDetailView *courseNewDetailView;

/**
 课程详情
 */
@property (nonatomic,assign) NSInteger courseID;

/*
 *  是否从首页推出来的详情
 */
@property (nonatomic,assign) BOOL isPushFromHome;

/*
 *  首页推出来的详情,加TYPE
 */
@property (nonatomic,assign) BATHealtFocusType courseType;

@end
