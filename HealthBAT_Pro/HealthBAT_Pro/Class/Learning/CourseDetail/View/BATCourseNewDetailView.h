//
//  BATCourseNewDetailView.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCourseDetailBottomView.h"
#import "BATCourseDetailHeaderView.h"

@interface BATCourseNewDetailView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) BATCourseDetailHeaderView *tableHeaderView;

@property (nonatomic,strong) BATCourseDetailBottomView *courseDetailBottomView;

@end
