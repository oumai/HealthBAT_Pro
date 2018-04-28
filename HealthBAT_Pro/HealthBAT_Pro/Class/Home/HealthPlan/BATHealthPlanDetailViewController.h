//
//  BATHealthPlanDetailViewController.h
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视频类型
 */
typedef NS_ENUM(NSInteger, BATHealthPlanVideoType) {
    BATHealthPlanMoulding = 1,
    BATHealthPlanBodyBuilding = 2,
    BATHealthPlanRegimen = 3,
};


@interface BATHealthPlanDetailViewController : UIViewController

@property (nonatomic,assign) BATHealthPlanVideoType type;

@end
