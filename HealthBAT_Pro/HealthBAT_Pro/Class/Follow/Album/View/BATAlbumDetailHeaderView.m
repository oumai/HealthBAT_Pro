//
//  BATAlbumDetailHeaderView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailHeaderView.h"

@interface BATAlbumDetailHeaderView ()<ZFPlayerDelegate>

@end

@implementation BATAlbumDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction {
    
    if (self.cilckBackBlock) {
        self.cilckBackBlock();
    }
}


- (void)configData:(BATAlbumDetailModel *)albumDetailModel
{

    //同个界面切换视频的时候需要先重置视频
    [self.playerView resetPlayer];
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = albumDetailModel.Data.Topic;
    model.placeholderImageURLString = albumDetailModel.Data.Poster;
    model.videoURL = [NSURL URLWithString:albumDetailModel.Data.AttachmentUrl];
    model.fatherView = self.fatherView;
    
    [self.playerView playerControlView:self.controlView playerModel:model];
    self.playerView.hasPreviewView = YES;
    
    // 自动播放
    [self.playerView autoPlayTheVideo];

}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.fatherView];
    
    WEAK_SELF(self);
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.bottom.right.top.equalTo(self);
    }];
}

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

- (ZFPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.isFromHealthFollow = YES;
    }
    return _controlView;
}


@end
