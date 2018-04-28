//
//  WKFRadarView.m
//  RadarDemo
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 吴凯锋 QQ:24272779. All rights reserved.
//

#import "BATRaderAnimation.h"
#import "BATIndefiniteAnimatedView.h"
#import "BATGetUserStatus.h"
@interface KFRadarButton ()

@end

@implementation KFRadarButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
    }
    return self;
}
-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window != nil) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        }];
    }
}
-(void)removeFromSuperview
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(callSuperRemoveSuperView)];
    [UIView commitAnimations];
    
}
-(void)callSuperRemoveSuperView
{
    [super removeFromSuperview];
}

@end

@interface BATRaderAnimation()
{
    CGSize itemSize;
    NSMutableArray *items ;
}

@property (nonatomic,weak)CALayer *animationLayer;
@property (nonatomic, strong) BATIndefiniteAnimatedView *inView;

@property (nonatomic,weak)CALayer *thumbnailLayer;
@property (nonatomic ,strong) UIImageView *imageV;

@property (strong, nonatomic) UIBezierPath *bPath;

@property (nonatomic, strong) BATGetUserStatus *needStatus;
@end

@implementation BATRaderAnimation
-(instancetype)initWithFrame:(CGRect)frame andThumbnail:(NSString *)thumbnailUrl
{
    if (self = [super initWithFrame:frame]) {
        //当重后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:@"PulsingRadarView_animation" object:nil];
        self.backgroundColor = [UIColor clearColor];
        items = [[NSMutableArray alloc]init];
        itemSize = CGSizeMake(0, 0);
//        self.thumbnailImage = [UIImage imageNamed:thumbnailUrl];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor]setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 1;
    double animationDuration = 2;
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        CAShapeLayer * pulsingLayer = [[CAShapeLayer alloc]init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
        pulsingLayer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = rect.size.height/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
//        CABasicAnimation *path = [CABasicAnimation animationWithKeyPath:@"path"];
       
        
        
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.8];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    self.animationLayer.zPosition = -1;//重新加载时，使动画至底层
    [self.layer addSublayer:self.animationLayer];
    
    CALayer * thumbnailLayer = [[CALayer alloc]init];
    thumbnailLayer.backgroundColor = [UIColor clearColor].CGColor;
    CGRect thumbnailRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.65,  [UIScreen mainScreen].bounds.size.width * 0.66);
    thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
    thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
    thumbnailLayer.frame = thumbnailRect;
    thumbnailLayer.cornerRadius = thumbnailRect.size.width * 0.5;
    thumbnailLayer.borderWidth = 1.0;
    thumbnailLayer.masksToBounds = YES;
    thumbnailLayer.borderColor = [UIColor clearColor].CGColor;
    UIImage * thumbnail = self.thumbnailImage;
    thumbnailLayer.contents = (id)thumbnail.CGImage;
    thumbnailLayer.zPosition = -1;
    _thumbnailLayer = thumbnailLayer;
    [self.layer addSublayer:thumbnailLayer];
    
    
//    [self addSubview:self.inView];
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima1.fromValue = [NSNumber numberWithFloat:-M_PI];
    anima1.toValue = [NSNumber numberWithFloat:M_PI];
    anima1.duration = 3.0;
    anima1.repeatCount = HUGE;
    [self.imageV.layer addAnimation:anima1 forKey:nil];
     [self addSubview:self.imageV];
}
- (BATIndefiniteAnimatedView *)inView {
    
    if (!_inView ) {
        BATIndefiniteAnimatedView *layer = [[BATIndefiniteAnimatedView alloc] init];
        layer.strokeColor = [UIColor redColor];
        layer.strokeThickness = 2;
        layer.radius = _thumbnailLayer.cornerRadius + 2;
        layer.center = _thumbnailLayer.position;
        //    [self.layer addSublayer:layer.layer];
        _inView = layer;
    }
    return _inView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.6 + 30, [UIScreen mainScreen].bounds.size.width * 0.6 + 30)];
//        _imageV.center = CGPointMake(self.center.x, self.view.center.y);
        _imageV.center = _thumbnailLayer.position;
        
        NSString *str = @"light";
        
        
        if (self.needStatus.userStatus == pinkStatus) {
            
            str = @"light_p";
        }
        _imageV.image = [UIImage imageNamed:str];
       
    }
    return _imageV;
}
-(void)addOrReplaceItem
{
    
    
    NSInteger maxCount = 6;
    KFRadarButton *prButton = [[KFRadarButton alloc]initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [prButton setImage:[UIImage imageNamed:@"icon_age_press"] forState:UIControlStateNormal];
    prButton.layer.cornerRadius = 20;
    prButton.layer.masksToBounds = YES;
    
    do {
        CGPoint point = [self generateCenterPointInRadar];
        prButton.center = CGPointMake(point.x, point.y);
        
    } while ([self itemFrameIntersectsInOtherItem:prButton.frame]);
    
    [self addSubview:prButton];
    [items addObject:prButton];
    
    if (items.count > maxCount) {
        UIView * view = items[0];
        [view removeFromSuperview];
        [items removeObject:view];
    }
}

-(BOOL)itemFrameIntersectsInOtherItem:(CGRect)frame
{
    for (KFRadarButton *item in items) {
        if (CGRectIntersectsRect(item.frame, frame)) {
            return YES;
        }
    }
    return NO;
}

-(CGPoint)generateCenterPointInRadar
{
    double angle = arc4random()%360;
    double radius = ((NSInteger)arc4random()) % ((NSInteger)((self.bounds.size.width - itemSize.width)/2));
    double x = cos(angle) * radius;
    double y = sin(angle) * radius;
    return CGPointMake(x + self.bounds.size.width/2, y + self.bounds.size.height/2);
    
}

-(void)resume
{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}
- (UIBezierPath *)bPath {
    
    if (!_bPath) {
        
        
    }
    return _bPath;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (BATGetUserStatus *)needStatus {
    
    if (!_needStatus) {
        
        _needStatus = [[BATGetUserStatus alloc] init];
    }
    return _needStatus;
    
}
- (void)setHelpStrig:(NSString *)helpStrig {

    _helpStrig = helpStrig;
    
     NSString *str = @"light";
    if (self.needStatus.userStatus == pinkStatus) {
        
        str = @"light_p";
    }
    _imageV.image = [UIImage imageNamed:str];
    
    NSString *imgStr1 = @"circles_q";
    NSString *newStr1 = [self.needStatus changeStringByStatusWithString:imgStr1];
    //    self.animationView.thumbnailImage = [UIImage imageNamed:newStr1];

    UIImage *image = [UIImage imageNamed:newStr1];
     self.thumbnailImage = nil;
    _thumbnailLayer.contents = nil;
    [_thumbnailLayer removeFromSuperlayer];
//    _thumbnailLayer.contents = (id)image.CGImage;
    self.thumbnailImage = image;
    
}

@end

