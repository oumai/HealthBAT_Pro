//
//  BATMoreRecommendDoctorsAndFriendsViewController.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATMoreRecommendDoctorAndFriendsView.h"

@interface BATMoreRecommendDoctorsAndFriendsViewController : UIViewController

@property (nonatomic,strong) BATMoreRecommendDoctorAndFriendsView *moreRecommendDoctorAndFriendsView;

/**
 *  推荐类型 好友，医生
 */
@property (nonatomic,assign) BATRecommendType recommendType;

@end
