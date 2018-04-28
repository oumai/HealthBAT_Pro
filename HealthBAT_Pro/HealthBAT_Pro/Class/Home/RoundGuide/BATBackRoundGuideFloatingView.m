//
//  BATBackRoundGuideFloatingView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBackRoundGuideFloatingView.h"

@interface BATBackRoundGuideFloatingView ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation BATBackRoundGuideFloatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self pageLayout];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [self addGestureRecognizer:tap];
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

#pragma mark - Action
- (void)tapAction
{
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController presentViewController:appDelegate.navHomeVC animated:NO completion:nil];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.imageView];
    
    WEAK_SELF(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"but-fhdh"]];
    }
    return _imageView;
}

@end
