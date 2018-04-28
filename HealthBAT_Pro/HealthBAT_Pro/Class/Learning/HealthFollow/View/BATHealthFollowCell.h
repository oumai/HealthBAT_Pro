//
//  BATHealthFollowCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATHealthFollowCategoryView.h"
#import "BATCourseModel.h"

typedef void(^HealthCourseClick)(BATCourseData *courseData);

@interface BATHealthFollowCell : UITableViewCell

/**
 分类view
 */
@property (nonatomic,strong) BATHealthFollowCategoryView *categoryView;

/**
 分类下课程列表CollectionView
 */
@property (nonatomic,strong) UICollectionView *collectionView;

/**
 课程点击Block
 */
@property (nonatomic,strong) HealthCourseClick healthCourseClick;

@end
