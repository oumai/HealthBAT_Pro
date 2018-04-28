//
//  BATHealthFollowTableCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATPassTableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATCourseModel.h"

typedef void(^CourseClicked)(BATCourseData *courseData);

@interface BATHealthFollowTableCell : UICollectionViewCell <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**
 课程列表
 */
@property (nonatomic,strong) BATPassTableView *tableView;

/**
 分类ID
 */
@property (nonatomic,assign) NSInteger ObjID;

/**
 数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 是否刷新
 */
@property (nonatomic,assign) BOOL isRefresh;

/**
 页码
 */
@property (nonatomic,assign) NSInteger pageIndex;

/**
 是否滑动
 */
@property (nonatomic,assign) BOOL canScroll;

/**
 课程点击
 */
@property (nonatomic,strong) CourseClicked courseClicked;

/**
 加载课程数据

 @param complete 回调Block
 */
- (void)requestSpecialtyTopicList:(void(^)(BOOL isFinish))complete;

@end
