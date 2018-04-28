//
//  BATCourseDetailViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/8.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseDetailView.h"

@interface BATCourseDetailViewController : UIViewController

@property (nonatomic,strong) BATCourseDetailView *courseDetailView;

@property (nonatomic,assign) NSInteger courseID;

@property (nonatomic,assign) BATCourseType courseType;

@property (nonatomic,strong) NSString *pathName;

@property (nonatomic,assign) BOOL isSaveOpera;

@end
