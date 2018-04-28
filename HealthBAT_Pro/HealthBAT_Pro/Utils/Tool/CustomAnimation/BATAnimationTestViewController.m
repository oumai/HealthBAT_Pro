//
//  BATAnimationTestViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 17/9/132017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAnimationTestViewController.h"

#define ANIMATION_VIEW_WIDTH 200

@interface BATAnimationTestViewController ()

@property (nonatomic,strong) UIView *animationBackView;
@property (nonatomic,strong) UIImageView *lineImageView;

@end

@implementation BATAnimationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    CALayer * spreadLayer;
    spreadLayer = [CALayer layer];
    CGFloat diameter = ANIMATION_VIEW_WIDTH+30;  //扩散的大小
    spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
    spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
    spreadLayer.position = CGPointMake(ANIMATION_VIEW_WIDTH/2.0, ANIMATION_VIEW_WIDTH/2.0);
    spreadLayer.backgroundColor = [[UIColor greenColor] CGColor];
    [self.animationBackView.layer insertSublayer:spreadLayer below:self.animationBackView.layer];//把扩散层放到头像按钮下面
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 3;
    animationGroup.repeatCount = INFINITY;//重复无限次
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = defaultCurve;
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @1;//开始的大小
    scaleAnimation.toValue = @1.3;//最后的大小
    scaleAnimation.duration = 3;//动画持续时间
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 3;
    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
    opacityAnimation.removedOnCompletion = NO;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
    [spreadLayer addAnimation:animationGroup forKey:@"pulse"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPages {
    
    [self.view addSubview:self.animationBackView];
    [self.animationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(ANIMATION_VIEW_WIDTH, ANIMATION_VIEW_WIDTH));
    }];
}

- (UIView *)animationBackView {
    
    if (!_animationBackView) {
        
        _animationBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _animationBackView.layer.cornerRadius = ANIMATION_VIEW_WIDTH/2.0;
    }
    return _animationBackView;
}

- (UIImageView *)lineImageView {
    
    if (!_lineImageView) {
        
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-sg"]];
        
    }
    return _lineImageView;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
