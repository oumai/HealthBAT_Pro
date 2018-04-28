//
//  BATNavHomeView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNavHomeView.h"

@interface BATNavHomeView ()

@property (nonatomic,assign) CGPoint beginPoint;

@property (nonatomic,assign) CGPoint currentPoint;

@property (nonatomic,strong) CADisplayLink *link;

@end

@implementation BATNavHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

#pragma mark - Action
- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _beginPoint = self.downImageView.center;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        _currentPoint = [panGesture locationInView:self];
        
        if (_currentPoint.y < _beginPoint.y) {
            self.link.paused = NO;
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        self.link.paused = YES;
        [self.link invalidate];
        self.link = nil;
    }
}

- (void)updateDownImage {
    self.downImageView.center = CGPointMake(_beginPoint.x, _currentPoint.y);
    if (self.downBlock) {
        self.link.paused = YES;
        [self.link invalidate];
        self.link = nil;
        self.downImageView.center = CGPointMake(_beginPoint.x, _beginPoint.y);
        self.downBlock();
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.link.paused = YES;
    [self.link invalidate];
    self.link = nil;
    
    if (self.downBlock) {
        self.downBlock();
    }
}

- (void)downImageAnimate {
    CABasicAnimation *postionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    postionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    postionAnimation.duration = 1.0f;
    postionAnimation.autoreverses = YES;
    postionAnimation.repeatCount = HUGE_VALF;
    postionAnimation.toValue = iPhoneX ? [NSNumber numberWithFloat:SCREEN_HEIGHT - 25] : [NSNumber numberWithFloat:SCREEN_HEIGHT - 5];
    
    [self.downImageView.layer addAnimation:postionAnimation forKey:nil];
}

#pragma mark - pageLayout
- (void)pageLayout {
//    [self addSubview:self.scrollView];
    
    [self addSubview:self.downImageView];
    [self addSubview:self.jkdaBtn];
    [self addSubview:self.gohomeView];

    WEAK_SELF(self);
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        iPhoneX ? make.bottom.equalTo(self.mas_bottom).offset(-20) : make.bottom.equalTo(self.mas_bottom);
        make.size.mas_offset(CGSizeMake(75, 17));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.jkdaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@-15);
    }];
    
    [self.gohomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.jkdaBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(85, 20));
    }];
}

#pragma mark - get & set
//- (UIScrollView *)scrollView
//{
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.pagingEnabled = YES;
////        _scrollView.contentSize = CGSizeMake(0, 2 * SCREEN_HEIGHT);
//        _scrollView.bounces = NO;
//    }
//    return _scrollView;
//}

- (UIImageView *)downImageView
{
    if (_downImageView == nil) {
        _downImageView = [[UIImageView alloc] init];
        _downImageView.lee_theme.LeeConfigImage(RoundGuide_bat_Slide);
        _downImageView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_downImageView addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_downImageView addGestureRecognizer:tap];
    }
    return _downImageView;
}

- (BATGoHomeView *)gohomeView {
    if (!_gohomeView) {
        _gohomeView = [[BATGoHomeView alloc] initWithFrame:CGRectZero];
        
        WEAK_SELF(self);
        [_gohomeView setTapped:^{
            STRONG_SELF(self);
            if (self.goHomeBlock) {
                self.goHomeBlock();
            }
        }];
    }
    return _gohomeView;
}

- (UIButton *)jkdaBtn {
    if (!_jkdaBtn) {
        _jkdaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jkdaBtn.lee_theme.LeeConfigButtonImage(RoundGuide_bat_jkda, UIControlStateNormal);
        [_jkdaBtn sizeToFit];
        
        WEAK_SELF(self);
        [_jkdaBtn bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.goJkdaBlock) {
                self.goJkdaBlock();
            }
        }];
    }
    return _jkdaBtn;
}

- (CADisplayLink *)link {
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDownImage)];
        _link.paused = YES;
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

@end
