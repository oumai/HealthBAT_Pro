//
//  BATAlbumDetailHeaderView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZFPlayerView.h"
#import "BATAlbumDetailModel.h"

@interface BATAlbumDetailHeaderView : UIView
/**
 播放器父view
 */
@property (nonatomic,strong) UIView *fatherView;

/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView *playerView;

/**
 播放器操作View,用于显示播放完成之后的操作
 */
@property (nonatomic,strong) ZFPlayerControlView *controlView;

@property (nonatomic,copy) void(^cilckBackBlock)(void);

- (void)configData:(BATAlbumDetailModel *)albumDetailModel;

@end
