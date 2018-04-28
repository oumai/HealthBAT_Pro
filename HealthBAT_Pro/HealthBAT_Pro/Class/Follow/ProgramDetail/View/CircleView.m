//
//  CircleView.m
//  Demo
//
//  Created by chavez on 2017/3/1.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "CircleView.h"
#define UIColorFromHEX(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define ZZRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0

@interface CircleView ()

@property (nonatomic,weak) CAGradientLayer *gradientLayer;

@property (nonatomic,weak) CAGradientLayer *gradientLayer2;

@property (nonatomic,weak) CAShapeLayer *maskLayer;

@property (nonatomic,weak) CAShapeLayer *maskLayer2;

@property (nonatomic,strong)UIBezierPath *bPath;

@property (nonatomic,strong)UIBezierPath *bPath2;

@property (nonatomic,strong) UIView *circleView;


@end


@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setupGradientLayer];
        [self setupMaskLayer];
        
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    self.backgroundColor = [UIColor lightGrayColor];
    [self setupGradientLayer];
    [self setupMaskLayer];
}

- (void)setupMaskLayer{
    CGPoint centerP = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _bPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:70
                                        startAngle:-M_PI_2 endAngle:M_PI  clockwise:YES];
    _bPath.lineCapStyle = kCGLineCapRound;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = BASE_BACKGROUND_COLOR.CGColor;
    layer.path = _bPath.CGPath;
    layer.lineWidth = 20;
    layer.lineCap = kCALineCapRound;

    self.maskLayer = layer;
    self.gradientLayer.mask = layer;
    
}


- (void)setupGradientLayer{
    
    CGPoint centerP = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _bPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:70 startAngle:-M_PI_2 endAngle:M_PI + M_PI_2  clockwise:YES];
    _bPath.lineCapStyle = kCGLineCapRound;
    
    CAShapeLayer *layer1 = [[CAShapeLayer alloc] init];
    layer1.frame = self.bounds;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = BASE_BACKGROUND_COLOR.CGColor;
    layer1.path = _bPath.CGPath;
    layer1.lineWidth = 15;
    [self.layer addSublayer:layer1];
    
    
    UIColor *_inputColor0 = UIColorFromHEX(0X0182eb, 1);
    UIColor *_inputColor1 = UIColorFromHEX(0X0ee7f0, 1);
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.frame = self.bounds;
    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.locations = @[@(0.4)];
    self.gradientLayer = layer;
    [self.layer addSublayer:layer];
    
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    
    CGPoint centerP = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _bPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:70
                                        startAngle:-M_PI_2 endAngle:M_PI * 2 *_progress - M_PI_2 clockwise:YES];
    _bPath.lineCapStyle = kCGLineCapRound;
    self.maskLayer.path = nil;
    self.maskLayer.path = _bPath.CGPath;
    
}


@end
