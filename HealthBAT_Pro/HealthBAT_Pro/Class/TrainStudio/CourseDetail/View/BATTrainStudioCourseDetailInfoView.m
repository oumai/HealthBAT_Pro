//
//  BATTrainStudioCourseDetailInfoView.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioCourseDetailInfoView.h"


@interface BATTrainStudioCourseDetailInfoView () <ZFPlayerDelegate>

@end

@implementation BATTrainStudioCourseDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self =  [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

- (void)configData:(BATTrainStudioCourseDetailModel *)courseDetailModel
{
    
    if (courseDetailModel !=nil) {
        
        ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
        model.title = courseDetailModel.Data.CourseTitle;
        model.placeholderImageURLString = courseDetailModel.Data.Poster;
        model.videoURL = [NSURL URLWithString:[[courseDetailModel.Data.AttachmentUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        model.fatherView = self.fatherView;
        
        [self.playerView playerControlView:self.controlView playerModel:model];
        self.playerView.hasPreviewView = YES;
        
//        if (isWifi) {
//            // 自动播放
//            [self.playerView autoPlayTheVideo];
//        }
    }
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction
{
    
    if (self.cilckBackBlock) {
        self.cilckBackBlock();
    }
}


- (void)pageLayout
{
    
    [self addSubview:self.fatherView];
    
    WEAK_SELF(self);
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}


#pragma mark - get & set
- (UIView *)fatherView
{
    if (_fatherView == nil) {
        _fatherView = [[UIView alloc] init];
        _fatherView.backgroundColor = [UIColor blackColor];
    }
    return _fatherView;
}

- (ZFPlayerView *)playerView
{
    if (_playerView == nil) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    }
    return _playerView;
}

- (BATPlayVideoView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[BATPlayVideoView alloc] init];
//        _controlView.moreButton.hidden = YES;
        _controlView.repeatButton.hidden = YES;
    }
    return _controlView;
}

@end
