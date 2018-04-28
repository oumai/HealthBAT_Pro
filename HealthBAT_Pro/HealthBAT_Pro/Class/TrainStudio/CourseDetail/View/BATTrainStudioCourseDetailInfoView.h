//
//  BATTrainStudioCourseDetailInfoView.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZFPlayerView.h"
#import "BATPlayVideoView.h"

#import "BATTrainStudioCourseDetailModel.h"

@interface BATTrainStudioCourseDetailInfoView : UIView


/**
 播放器父view
 */
@property (nonatomic,strong) UIView *fatherView;

/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView *playerView;

/**
 播放器操作View
 */
@property (nonatomic,strong) BATPlayVideoView *controlView;

@property (nonatomic,copy) void(^cilckBackBlock)(void);

- (void)configData:(BATTrainStudioCourseDetailModel *)courseDetailModel;

@end
