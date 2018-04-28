//
//  ZFPlayerControlView.h
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

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "ZFPlayer.h"
#import "BATCoursePlayerCustomButton.h"
#import "BATCoursePlayerTestButton.h"

typedef void(^ChangeResolutionBlock)(UIButton *button);
typedef void(^SliderTapBlock)(CGFloat value);

@interface ZFPlayerControlView : UIView

/**
 测试按钮
 */
@property (nonatomic,strong) BATCoursePlayerTestButton *testButton;

/**
 重播按钮
 */
@property (nonatomic,strong) BATCoursePlayerCustomButton *repeatButton;
/**
 关注公众号按钮
 */
@property (nonatomic,strong) BATCoursePlayerCustomButton *followQRCodeButton;
/**
 更多按钮
 */
@property (nonatomic,strong) BATCoursePlayerCustomButton *moreButton;

/**
 测试标题
 */
@property (nonatomic,strong) UILabel *testTitleLabel;

/**
 是否有测试
 */
@property (nonatomic,assign) BOOL isTest;

/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;

@property (nonatomic, assign) BOOL isFromHealthPlan;
@property (nonatomic, copy) void(^backBtnClick)(void);
@property (nonatomic, copy) void(^fullScreenBtnClick)(void);
@property (nonatomic, copy) void(^resignTextInputView)(void);

//全屏分享与收藏按钮
@property (nonatomic,assign) BOOL isFromHealthFollow;
@property (nonatomic,copy) void(^shareBtnClick)(void);
@property (nonatomic,copy) void(^collectionBtnClick)(void);
/** 分享按钮 */
@property (nonatomic, strong) UIButton                *shareBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton                *collectionBtn;

- (void)fullScreenBtnClick:(UIButton *)sender;

//wct
- (void)hideControlView;
/** 播放完了 */
- (void)zf_playerPlayEnd;

@end
