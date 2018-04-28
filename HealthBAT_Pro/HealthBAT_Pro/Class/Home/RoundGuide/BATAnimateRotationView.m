//
//  BATTextView.m
//  iOS Demo
//
//  Created by 黄帆 on 2017/11/29.
//

#import "BATAnimateRotationView.h"
#import "BATGetUserStatus.h"
static NSString  *const rotaStr = @"rotation";
static NSString  *const pulsingStr = @"pulsing";
 double animationDuration = 2;
@interface BATAnimateRotationView()<CAAnimationDelegate>

@property (strong, nonatomic) UIView *boWenView;

@property (nonatomic ,strong) UIImageView *imageV;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) BATGetUserStatus *needStatus;

@property (nonatomic ,strong) CAShapeLayer * pulsingLayer ;

@property (nonatomic, strong) NSString *IMGSTR;
@end


@implementation BATAnimateRotationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
       
        [self updateOurView];
    }
    return self;
    
}

- (void)updateOurView {
    
    if (!_IMGSTR || _IMGSTR.length == 0) {
        [self decideIMG];
    }
    [self addSubview:self.imageV];
//    [self addSubview:self.contentIMGV];

    _timer = [NSTimer scheduledTimerWithTimeInterval:4 + 3 + 1 target:self selector:@selector(baseAni) userInfo:nil repeats:YES];

    [self baseAni];
}

//核心动画1
- (void)baseAni {

   
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima1.fromValue = [NSNumber numberWithFloat:0];
    anima1.toValue = [NSNumber numberWithFloat:2 * M_PI];
    anima1.duration = animationDuration;
    anima1.repeatCount = 0;
    anima1.removedOnCompletion= NO;
    anima1.delegate = self;
    [self.imageV.layer addAnimation:anima1 forKey:rotaStr];
    [self addSubview:self.imageV];
    
    [self decideIMG];
    UIImage *image = [UIImage imageNamed:_IMGSTR];
    self.imageV.image = image;
}
- (void)baseAni2 {

   
    CAShapeLayer * pulsingLayer = [[CAShapeLayer alloc]init];
    _pulsingLayer = pulsingLayer;
    pulsingLayer.frame = CGRectMake(0, 0, self.imageV.frame.size.width, self.imageV.frame.size.height);
    pulsingLayer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.width * 0.5);

//    pulsingLayer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    pulsingLayer.backgroundColor = [UIColor clearColor].CGColor;
    pulsingLayer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    pulsingLayer.borderWidth = 10.0;
    pulsingLayer.cornerRadius = self.imageV.frame.size.height/2;



    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
    animationGroup.fillMode = kCAFillModeBoth;
//    animationGroup.beginTime = CACurrentMediaTime() + (double)1 * animationDuration;
    animationGroup.duration = animationDuration + 1;        animationGroup.repeatCount = HUGE_VAL;
    animationGroup.timingFunction = defaultCurve;
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = [NSNumber numberWithDouble:1];
    scaleAnimation.toValue = [NSNumber numberWithDouble:1.5];
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
    opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
    animationGroup.animations = @[scaleAnimation,opacityAnimation];
    //确保获取到对象
    animationGroup.removedOnCompletion= NO;
    animationGroup.delegate = self;
    animationGroup.repeatCount = 0;
    [pulsingLayer addAnimation:animationGroup forKey:pulsingStr];

    [self.layer addSublayer:pulsingLayer];
    
    [self bringSubviewToFront:self.contentIMGV];
}



//view动画  ---不行的样子
//- (void)ani {
//
//    [UIView animateWithDuration:1 animations:^{
//
//        CGAffineTransform transform =  CGAffineTransformRotate(self.imageV.transform, M_PI);;
//
//        self.imageV.transform = transform;
//    } completion:^(BOOL finished) {
//

//    }];
//}
- (void)decideIMG {
    
    if (self.needStatus.userStatus == pinkStatus) {
        _IMGSTR = @"light_p";
    } else {
        
        _IMGSTR = @"light";
        
    }
    
   
    
}
- (UIImageView *)imageV {
    if (!_imageV) {

        
        UIImage *image = [UIImage imageNamed:_IMGSTR];
        _imageV = [[UIImageView alloc] init];
        _imageV.bounds = self.frame;
        _imageV.center  = CGPointMake(self.frame.size.width * 0.5, self.frame.size.width * 0.5);
        _imageV.image = image;
        
    }
    return _imageV;
}

- (UIImageView *)contentIMGV {
    if (!_contentIMGV) {
        _contentIMGV = [[UIImageView alloc] init];
        _contentIMGV.bounds =  self.frame;
        _contentIMGV.center  = CGPointMake(self.frame.size.width * 0.5, self.frame.size.width * 0.5);
        _contentIMGV.layer.cornerRadius = self.frame.size.width * 0.5;
        _contentIMGV.layer.masksToBounds = YES;
    }
    return _contentIMGV;
}
- (BATGetUserStatus *)needStatus {
    
    if (!_needStatus) {
        
        _needStatus = [[BATGetUserStatus alloc] init];
    }
    return _needStatus;
    
}
- (void)setHelpStr:(NSString *)helpStr {
    
    _helpStr = helpStr;
    
    [self decideIMG];
    
    
}
#pragma mark - delegate
- (void)animationDidStart:(CAAnimation *)anim;
{
    
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag; {
    
    if (anim==[self.imageV.layer animationForKey:rotaStr]) {
       
        [self.imageV removeFromSuperview];
        
        [self baseAni2];
    } else if (anim==[self.pulsingLayer animationForKey:pulsingStr]) {
        
        [self.pulsingLayer removeFromSuperlayer];
        
        
    }

}
@end
