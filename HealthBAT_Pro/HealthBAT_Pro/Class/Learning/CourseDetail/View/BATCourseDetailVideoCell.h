//
//  BATCourseDetailVideoCell.h
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayerView.h"
#import "BATCourseDetailModel.h"

@interface BATCourseDetailVideoCell : UITableViewCell

/**
 播放器父view
 */
@property (nonatomic,strong) UIView *fatherView;

/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView *playerView;

- (void)configData:(BATCourseDetailModel *)courseDetailModel;

@end
