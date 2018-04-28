//
//  MyFocusViewController.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  我关注的健康圈
 */
typedef NS_ENUM(NSInteger, BATMomentType) {
    /**
     *  全部
     */
    kAll                   = -1,
    /**
     *  动态
     */
    kMoment                = 0,
    /**
     *  问题
     */
    kQusetion              = 1
};

@interface BATMyFocusViewController : UIViewController

@property (nonatomic,assign) BATMomentType type;

@end
