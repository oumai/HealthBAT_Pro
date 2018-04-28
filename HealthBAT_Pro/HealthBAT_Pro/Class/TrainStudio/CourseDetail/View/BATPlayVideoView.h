//
//  BATPlayVideoView.h
//  HealthBAT_Pro
//
//  Created by four on 2017/4/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "ZFPlayerControlView.h"

@interface BATPlayVideoView : ZFPlayerControlView


/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;

@property (nonatomic,copy) NSString *totalTime;

@property (nonatomic,strong) NSString *fileSize;

- (void)zf_playerPlayEnd;

@end
