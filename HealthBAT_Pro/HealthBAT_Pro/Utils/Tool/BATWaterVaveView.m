//
//  BATWaterVaveView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWaterVaveView.h"

#define kPulseAnimation @"kPulseAnimation"

@interface BATWaterVaveView ()<CAAnimationDelegate>
@end
@implementation BATWaterVaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
     [self drawWaveAnimationLayerWithView:self diameter:440/2 duration:1.2];
}

//画圆环
- (void)drawCirque{
   
    CGFloat radius = self.frame.size.width * 0.5;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [[UIColor whiteColor] setFill];
    [path fill];
    
    //绘制路径
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineWidth = 10;
    pathLayer.strokeColor = [UIColor blueColor].CGColor;
    pathLayer.fillColor = [UIColor clearColor].CGColor; // 默认为blackColor
    pathLayer.path = path.CGPath;
    [self.layer addSublayer:pathLayer];
    
    //创建动画
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    checkAnimation.repeatCount = MAXFLOAT;
    checkAnimation.duration = 5.0;
    checkAnimation.delegate = self;
    [pathLayer addAnimation:checkAnimation forKey:@"checkAnimation"];

}

//diameter 扩散的大小
- (void)drawWaveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter duration:(CGFloat)duration {
    
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    waveLayer.position = view.center;
    waveLayer.backgroundColor = [UIColor redColor].CGColor;
    [view.superview.layer insertSublayer:waveLayer below:view.layer];
    
    //添加动画
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = MAXFLOAT; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    //添加缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @1.0; //开始的大小
    scaleAnimation.toValue = @1.5; //最后的大小
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1.0, @0.5,@0.0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.5,@1.0];//关键帧
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:@"animationGroup"];
}

//动画开始调用
-(void)animationDidStart:(CAAnimation *)anim
{
    
}
//动画结束调用
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
