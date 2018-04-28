//
//  BATCollectionListViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATCollectionListView.h"

/**
 *  收藏类型
 */
typedef NS_ENUM(NSInteger,BATCollectionType) {
    /**
     *  医生
     */
    BATCollectionDoctor = 0,
    /**
     *  医院
     */
    BATCollectionHospital,
    /**
     *  资讯
     */
    BATCollectionNews,
    /**
     *  课程
     */
    BATCollectionLessons,
};

@interface BATCollectionListViewController : UIViewController

@property (nonatomic,strong) BATCollectionListView *collectionListView;

@property (nonatomic,assign) BATCollectionType collectionType;


@end
