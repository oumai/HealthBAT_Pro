//
//  ZFPlayerControlView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"

#import "BATCoursePlayerTestButton.h"
#import "BATCoursePlayerCustomButton.h"
#import "UIButton+TouchAreaInsets.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat ZFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZFPlayerControlView () <UIGestureRecognizerDelegate>
/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;
/** 重播按钮 */
//@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray                 *resolutionArray;

/** 播放模型 */
@property (nonatomic, strong) ZFPlayerModel           *playerModel;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;


@end

@implementation ZFPlayerControlView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        [self.topImageView addSubview:self.downLoadBtn];
        [self addSubview:self.lockBtn];
        [self.topImageView addSubview:self.backBtn];
        [self addSubview:self.activity];
//        [self addSubview:self.repeatBtn];
        [self addSubview:self.playeBtn];
        [self addSubview:self.failBtn];
        
        [self addSubview:self.repeatButton];
        [self addSubview:self.followQRCodeButton];
//        [self addSubview:self.testButton];
//        [self addSubview:self.moreButton];
//        [self addSubview:self.testTitleLabel];
        
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        
        [self.topImageView addSubview:self.resolutionBtn];
        [self.topImageView addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.bottomProgressView];
        
        //自定义分享按钮和收藏按钮
        [self addSubview:self.shareBtn];
        [self addSubview:self.collectionBtn];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.downLoadBtn.hidden     = YES;
        self.resolutionBtn.hidden   = YES;
        
        self.testButton.hidden = YES;
        self.testTitleLabel.hidden = YES;
        // 初始化时重置controlView
        [self zf_playerResetControlView];
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];

        [self listeningRotating];
        [self onDeviceOrientationChange];
        
        self.backBtn.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 10);
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)makeSubViewsConstraints
{
    WEAK_SELF(self);
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(50);
//        make.left.right.equalTo(self);
//        make.top.equalTo(@25);
//        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
//        make.top.equalTo(self.topImageView.mas_top).offset(7);
//        make.width.height.mas_equalTo(30);
        make.left.equalTo(self.topImageView.mas_left).offset(10);
        make.top.equalTo(self.topImageView.mas_top).offset(7);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(49);
//        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(40, 49));
        make.right.equalTo(self.topImageView.mas_right).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];

    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(25);
//        make.trailing.equalTo(self.downLoadBtn.mas_leading).offset(-10);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(40, 25));
        make.right.equalTo(self.downLoadBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
//        make.centerY.equalTo(self.backBtn.mas_centerY);
//        make.trailing.equalTo(self.resolutionBtn.mas_leading).offset(-10);
        make.left.equalTo(self.backBtn.mas_right).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.right.equalTo(self.resolutionBtn.mas_right).offset(-10).priorityLow();
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.leading.trailing.bottom.equalTo(self);
//        make.height.mas_equalTo(45);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
//        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
//        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.bottomImageView.mas_centerY);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.left.equalTo(self.bottomImageView.mas_left).offset(10);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
//        make.centerY.equalTo(self.startBtn.mas_centerY);
//        make.width.mas_equalTo(43);
        
        make.left.equalTo(self.startBtn.mas_right).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
//        make.width.mas_equalTo(43);
    }];
    
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        //        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        //        make.centerY.equalTo(self.startBtn.mas_centerY);
        
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(4).priorityLow();
        make.centerY.equalTo(self.startBtn.mas_centerY);
        
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        //        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        //        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        //        make.height.mas_equalTo(30);
        
        make.width.equalTo(self.progressView.mas_width);
//        make.left.equalTo(self.currentTimeLabel.mas_right).offset(4);
        make.centerY.equalTo(self.progressView.mas_centerY).offset(-1);
        make.centerX.equalTo(self.progressView.mas_centerX);
        make.height.mas_equalTo(30);
        
    }];
    
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        //        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        //        make.centerY.equalTo(self.startBtn.mas_centerY);
        //        make.width.mas_equalTo(43);
        make.left.equalTo(self.progressView.mas_right).offset(4).priorityLow();
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        //        make.width.mas_equalTo(43);
    }];

    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.width.height.mas_equalTo(30);
//        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
//        make.centerY.equalTo(self.startBtn.mas_centerY);
        
        make.size.mas_offset(CGSizeMake(30, 30));
        make.right.equalTo(self.bottomImageView.mas_right).offset(-10);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    
//    [self.repeatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.center.equalTo(self);
//    }];
    
    [self.repeatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(30, 50));
        
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-40);
        
    }];
    
    [self.followQRCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.repeatButton.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX).offset(40);
        make.size.mas_offset(CGSizeMake(80, 50));
    }];
    
//    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.center.equalTo(self);
//        make.size.mas_offset(CGSizeMake(82.5, 82.5));
//        make.left.equalTo(self.repeatButton.mas_right).offset(54);
//        make.right.equalTo(self.moreButton.mas_left).offset(-54);
//    }];
//    
//    [self.testTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.testButton.mas_bottom).offset(9);
//    }];
//    
//    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.centerY.equalTo(self.mas_centerY);
//        make.size.mas_offset(CGSizeMake(30, 50));
//    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(70);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-10);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    [self zf_playerCancelAutoFadeOutControlView];
    if (!self.isShrink && !self.isPlayEnd) {
        // 只要屏幕旋转就显示控制层
        [self zf_playerShowControlView];
    }
 
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender
{
    sender.selected = YES;
    if (sender.isSelected) {
        sender.backgroundColor = RGBA(86, 143, 232, 1);
    } else {
        sender.backgroundColor = [UIColor clearColor];
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:resolutionAction:)]) {
        [self.delegate zf_controlView:self resolutionAction:sender];
    }
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
            [self.delegate zf_controlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)backBtnClick:(UIButton *)sender
{

    //全屏下的返回会影藏按钮，这里设置NO
    self.topImageView.hidden = NO;
    
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
            [self.delegate zf_controlView:self closeAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
            [self.delegate zf_controlView:self backAction:sender];
        }
    }
    
    if (self.isFromHealthPlan) {
        
        if (self.backBtnClick) {
            self.backBtnClick();
        }
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.showing = NO;
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:lockScreenAction:)]) {
        [self.delegate zf_controlView:self lockScreenAction:sender];
    }
}

- (void)playBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:sender];
    }
}

- (void)closeBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
        [self.delegate zf_controlView:self closeAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender
{
//    sender.selected = !sender.selected;
//    self.topImageView.hidden = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:fullScreenAction:)]) {
        [self.delegate zf_controlView:self fullScreenAction:sender];
    }
    
    if (self.resignTextInputView) {
        self.resignTextInputView();
    }
    
    if (self.isFromHealthPlan == YES && sender.selected == NO) {
        
        if (self.fullScreenBtnClick) {
            self.fullScreenBtnClick();
        }
    }

}

- (void)repeatBtnClick:(UIButton *)sender
{
    // 重置控制层View
    [self zf_playerResetControlView];
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
        [self.delegate zf_controlView:self repeatPlayAction:sender];
    }
}

- (void)downloadBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zf_controlView:downloadVideoAction:)]) {
        [self.delegate zf_controlView:self downloadVideoAction:sender];
    }
}

- (void)resolutionBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
}

- (void)centerPlayBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zf_controlView:cneterPlayAction:)]) {
        [self.delegate zf_controlView:self cneterPlayAction:sender];
    }
}

- (void)failBtnClick:(UIButton *)sender
{
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:failAction:)]) {
        [self.delegate zf_controlView:self failAction:sender];
    }
}

- (void)shareBtnClick:(UIButton *)sender
{
    
    if (self.shareBtnClick) {
        self.shareBtnClick();
    }
}

- (void)collectionBtnClick:(UIButton *)sender
{
    
    if (self.collectionBtnClick) {
        self.collectionBtnClick();
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender
{
    [self zf_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender
{
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground
{
    [self zf_playerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground
{
    if (!self.isShrink) { [self zf_playerShowControlView]; }
}

- (void)playerPlayDidEnd
{
    self.backgroundColor  = RGBA(0, 0, 0, .6);
//    self.repeatBtn.hidden = NO;
    
    self.repeatButton.hidden = NO;
    self.followQRCodeButton.hidden = self.repeatButton.hidden;
  //  self.testButton.hidden = self.isTest ? NO : YES;
//    self.moreButton.hidden = NO;
  //  self.testTitleLabel.hidden = self.isTest ? NO : YES;
    
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zf_playerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{    
    if (ZFPlayerShared.isLockScreen) { return; }
//    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (ZFPlayerOrientationIsLandscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
    [self layoutIfNeeded];
}

- (void)setOrientationLandscapeConstraint
{
    self.shrink                 = NO;
    self.fullScreen             = YES;
//    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(27);
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint
{
    self.fullScreen             = NO;
//    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(7);
    }];

    if (self.isCellVideo) {
        [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    } else {
        if (iPhoneX) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
}

#pragma mark - Private Method

- (void)showControlView
{
    if (self.lockBtn.isSelected) {
        self.topImageView.alpha    = 0;
        self.bottomImageView.alpha = 0;
    } else {
        self.topImageView.alpha    = 1;
        self.bottomImageView.alpha = 1;
    }
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
    self.shrink                    = NO;
    self.bottomProgressView.alpha  = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (self.isFromHealthFollow) {
        
        if (self.isFullScreen) {
            self.shareBtn.hidden = NO;
            self.collectionBtn.hidden = NO;
        }
        else {
            self.shareBtn.hidden = YES;
            self.collectionBtn.hidden = YES;
        }
    }
}

- (void)hideControlView
{
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.lockBtn.alpha            = 0;
    self.bottomProgressView.alpha = 1;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionBtnClick:self.resolutionBtn];
    if (self.isFullScreen && !self.playeEnd) { [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; }
    
    if (self.isFromHealthFollow) {
        self.shareBtn.hidden = YES;
        self.collectionBtn.hidden = YES;
    }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}


- (void)autoFadeOutControlView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_playerHideControlView) object:nil];
    [self performSelector:@selector(zf_playerHideControlView) withObject:nil afterDelay:ZFPlayerAnimationTimeInterval];
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect
{
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - setter

- (void)setShrink:(BOOL)shrink
{
    _shrink = shrink;
    self.closeBtn.hidden = !shrink;
    self.bottomProgressView.hidden = shrink;
}

- (void)setIsTest:(BOOL)isTest
{
    _isTest = isTest;
    
    if (!_isTest) {
        WEAK_SELF(self)
        
        self.testButton.hidden = YES;
        self.testTitleLabel.hidden = YES;
        
        [self.testButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [self.testTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [self.repeatButton mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX).offset(-25);
        }];
        
        [self.moreButton mas_updateConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX).offset(25);
        }];
        

        

    }
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
//        _topImageView.image                  = ZFPlayerImage(@"ZFPlayer_top_shadow");
        _topImageView.hidden = NO;
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
//        _bottomImageView.image                  = ZFPlayerImage(@"ZFPlayer_bottom_shadow");
        _bottomImageView.image                  = [UIImage imageNamed:@"mask-bfq"];
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayerImage(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _lockBtn.hidden = YES;

    }
    return _lockBtn;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_startBtn setImage:ZFPlayerImage(@"ZFPlayer_play") forState:UIControlStateNormal];
//        [_startBtn setImage:ZFPlayerImage(@"ZFPlayer_pause") forState:UIControlStateSelected];
        
        [_startBtn setImage:[UIImage imageNamed:@"ic-play"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"ic-zt"] forState:UIControlStateSelected];
        
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_currentTimeLabel sizeToFit];
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
//        _progressView.progressTintColor = UIColorFromHEX(0xefb529, 1);
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;

//        [_videoSlider setThumbImage:ZFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"img-bfq"] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
//        _videoSlider.minimumTrackTintColor = UIColorFromHEX(0xeef0f2, 1);
//        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_totalTimeLabel sizeToFit];
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:ZFPlayerImage(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:ZFPlayerImage(@"ZFPlayer_shrinkscreen") forState:UIControlStateSelected];
//        [_fullScreenBtn setImage:[UIImage imageNamed:@"ic-full-screen"] forState:UIControlStateNormal];
//        [_fullScreenBtn setImage:[UIImage imageNamed:@"ic-full-screen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (MMMaterialDesignSpinner *)activity
{
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

//- (UIButton *)repeatBtn
//{
//    if (!_repeatBtn) {
//        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_repeatBtn setImage:ZFPlayerImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
//        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _repeatBtn;
//}

- (BATCoursePlayerCustomButton *)repeatButton
{
    if (_repeatButton == nil) {
        _repeatButton = [[BATCoursePlayerCustomButton alloc] init];
        _repeatButton.titleLabel.text = @"重播";
        _repeatButton.imageView.image = [UIImage imageNamed:@"ic-bf"];
        WEAK_SELF(self);
        _repeatButton.coursePlayerCustomButtonAction = ^(){
            STRONG_SELF(self);
            // 重置控制层View
            [self zf_playerResetControlView];
            [self zf_playerShowControlView];
            if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
                [self.delegate zf_controlView:self repeatPlayAction:self.repeatButton.button];
            }
        };
    }
    return _repeatButton;
}
- (BATCoursePlayerCustomButton *)followQRCodeButton
{
    if (_followQRCodeButton == nil) {
        _followQRCodeButton = [[BATCoursePlayerCustomButton alloc] init];
        _followQRCodeButton.titleLabel.text = @"关注公众号";
        _followQRCodeButton.imageView.image = [UIImage imageNamed:@"Follow_weixin"];

    }
    return _followQRCodeButton;
}

- (BATCoursePlayerCustomButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[BATCoursePlayerCustomButton alloc] init];
        _moreButton.titleLabel.text = @"更多";
        _moreButton.imageView.image = [UIImage imageNamed:@"ic-gd"];
    }
    return _moreButton;
}

- (BATCoursePlayerTestButton *)testButton
{
    if (_testButton == nil) {
        _testButton = [[BATCoursePlayerTestButton alloc] init];
//        _testButton.titleLabel.text = @"你的肾还好吗？来测一测";
//        _testButton.imageView.image = [UIImage imageNamed:@"img-cs"];
    }
    return _testButton;
}

- (UILabel *)testTitleLabel
{
    if (_testTitleLabel == nil) {
        _testTitleLabel = [[UILabel alloc] init];
        _testTitleLabel.font = [UIFont systemFontOfSize:15];
        _testTitleLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _testTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _testTitleLabel.text = @"你的肾还好吗？来测一测！";
    }
    return _testTitleLabel;
}

- (UIButton *)downLoadBtn
{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn setImage:ZFPlayerImage(@"ZFPlayer_download") forState:UIControlStateNormal];
        [_downLoadBtn setImage:ZFPlayerImage(@"ZFPlayer_not_download") forState:UIControlStateDisabled];
        [_downLoadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}

- (UIButton *)resolutionBtn
{
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (UIButton *)playeBtn
{
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:ZFPlayerImage(@"ZFPlayer_play_btn") forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

- (UIButton *)failBtn
{
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}

- (UIView *)fastView
{
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView
{
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel
{
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView
{
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}

- (UIProgressView *)bottomProgressView
{
    if (!_bottomProgressView) {
        _bottomProgressView                   = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = [UIColor whiteColor];
        _bottomProgressView.trackTintColor    = [UIColor clearColor];
    }
    return _bottomProgressView;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"ic-fx-w"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isFromHealthFollow == NO) {
            _shareBtn.hidden = YES;
        }
    }
    return _shareBtn;
}

- (UIButton *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:[UIImage imageNamed:@"ic-sc-w"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"icon-sc-d"] forState:UIControlStateSelected];
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isFromHealthFollow == NO) {
            _collectionBtn.hidden = YES;
        }
    }
    return _collectionBtn;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView
{
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
//    self.repeatBtn.hidden            = YES;
    
    self.repeatButton.hidden = YES;
    self.followQRCodeButton.hidden = self.repeatButton.hidden;
    self.testButton.hidden = YES;
    self.moreButton.hidden = YES;
    self.testTitleLabel.hidden = YES;
    
    self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.downLoadBtn.enabled         = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
//    self.lockBtn.hidden              = !self.isFullScreen;
    self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
}

- (void)zf_playerResetControlViewForResolution
{
    self.fastView.hidden        = YES;
//    self.repeatBtn.hidden       = YES;
    
    self.repeatButton.hidden = YES;
    self.followQRCodeButton.hidden = self.repeatButton.hidden;
    self.testButton.hidden = YES;
    self.moreButton.hidden = YES;
    self.testTitleLabel.hidden = YES;
    
    self.resolutionView.hidden  = YES;
    self.playeBtn.hidden        = YES;
    self.downLoadBtn.enabled    = YES;
    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.shrink                 = NO;
    self.showing                = NO;
    self.playeEnd               = NO;
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView
{
    self.showing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 设置播放模型 */
- (void)zf_playerModel:(ZFPlayerModel *)playerModel
{
    _playerModel = playerModel;
    if (playerModel.title) { self.titleLabel.text = playerModel.title; }
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        [self.placeholderImageView setImageWithURLString:playerModel.placeholderImageURLString placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
    if (playerModel.resolutionDic) {
        [self zf_playerResolutionArray:[playerModel.resolutionDic allKeys]];
    }
}

/** 正在播放（隐藏placeholderImageView） */
- (void)zf_playerItemPlaying
{
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}

/**
 *  显示控制层
 */
- (void)zf_playerShowControlView
{
    if (self.isShowing) {
        [self zf_playerHideControlView];
        return;
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];

}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView
{
    if (!self.isShowing) { return; }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay
{
    [self updateConstraints];
    [self layoutIfNeeded];
    [self hideControlView];
    self.shrink = YES;
}

/** 在cell播放 */
- (void)zf_playerCellPlay
{
    self.cellVideo = YES;
    self.shrink    = YES;
    [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
    [self layoutIfNeeded];
    [self zf_playerShowControlView];
}

- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value
{
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview
{
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = YES;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_backward");
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;

}

- (void)zf_playerDraggedEnd
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image;
{
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)zf_playerSetProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error
{
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated
{
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)zf_playerPlayEnd
{
//    self.repeatBtn.hidden = NO;
    
    self.repeatButton.hidden = NO;
    self.followQRCodeButton.hidden = self.repeatButton.hidden;
 //   self.testButton.hidden = self.isTest ? NO : YES;
//    self.moreButton.hidden = NO;
 //   self.testTitleLabel.hidden = self.isTest ? NO : YES;
    
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.bottomProgressView.alpha = 0;
}

/** 
 是否有下载功能 
 */
- (void)zf_playerHasDownloadFunction:(BOOL)sender
{
    self.downLoadBtn.hidden = !sender;
}

/**
 是否有切换分辨率功能
 */
- (void)zf_playerResolutionArray:(NSArray *)resolutionArray
{
    self.resolutionBtn.hidden = NO;
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.7);
    [self addSubview:self.resolutionView];
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom).offset(0);
    }];
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 25*i, 40, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = RGBA(86, 143, 232, 1);
        }
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state
{
    self.startBtn.selected = state;
}

/** 锁定屏幕方向按钮状态 */
- (void)zf_playerLockBtnState:(BOOL)state
{
    self.lockBtn.selected = state;
}

/** 下载按钮状态 */
- (void)zf_playerDownloadBtnState:(BOOL)state
{
    self.downLoadBtn.enabled = state;
}

//写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
#pragma clang diagnostic pop
@end
