//
//  BATPlayVideoView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPlayVideoView.h"

@implementation BATPlayVideoView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

/** 播放完了 */
- (void)zf_playerPlayEnd
{
    self.repeatButton.hidden = NO;
//    self.testButton.hidden = YES;
//    self.moreButton.hidden = YES;
//    self.testTitleLabel.hidden = YES;
    [self.repeatButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.bottomProgressView.alpha = 0;
}

//- (NSString *)totalTime
//{
//    if (_totalTime == nil) {
//        _totalTime = self.totalTimeLabel.text;
//    }
//    return _totalTime;
//}


@end
