//
//  BATAddressAlertView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddressAlertView.h"

@implementation BATAddressAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    
    self.alertView.layer.cornerRadius = 6.0f;
    self.alertView.layer.masksToBounds = YES;
    
    self.confrimButton.enbleGraditor = YES;
    self.confrimButton.enablehollowOut = YES;
    [self.confrimButton setGradientColors:@[START_COLOR,END_COLOR]];
    
    [self alertShowAnimate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - private

#pragma mark - Animate
- (void)alertShowAnimate
{
    self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alertView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Action
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    WEAK_SELF(window);
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(window);
        make.edges.equalTo(window);
    }];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self removeFromSuperview];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)confrimButtonAction:(id)sender
{
    [self removeFromSuperview];
    
    if (self.conrimBlock) {
        self.conrimBlock();
    }
}


@end
