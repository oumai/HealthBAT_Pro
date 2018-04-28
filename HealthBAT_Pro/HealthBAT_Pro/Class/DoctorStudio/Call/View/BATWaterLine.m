//
//  BATWaterLine.m
//  HealthBAT_Pro
//
//  Created by four on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWaterLine.h"

@interface BATWaterLine ()
{
    UIColor *_currentWaterColor;
    
    float _currentLinePointY;
    
    float a;
    float b1;
    float b2;
    float b3;
    
    BOOL jia;
}
@end

@implementation BATWaterLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        a = 1.5;
        b1 = 0;
        b2 = 0;
        b3 = 0;
        jia = NO;
        
//        _currentWaterColor = [UIColor whiteColor];
        _currentLinePointY = 15;//30 高度10加距离位置20
        
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=1.5) {
        jia = NO;
    }
    
    
    b1+=0.005;//0.05 控制波动速度
    b2+=0.015;
    b3+=0.025;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self line1];
    
    [self line2];
    
    [self line3];
}

- (void)line1{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    //设置填充颜色
    //    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    //设置线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColorFromHEX(0x23ffdd,1) CGColor]);
    
    float y=_currentLinePointY;
    
    CGPathMoveToPoint(path, NULL, -5, y);//-5 去掉上线波动小段
    
    
    for(float x=0;x<=SCREEN_WIDTH;x++){
        y= a * sin( x/180*M_PI + 4*b1/M_PI ) * 10 + _currentLinePointY ;
        CGPathAddLineToPoint(path, nil, x, y);//10 控制波动高度
    }
    //    CGPathAddLineToPoint(path, nil, 320, rect.size.height);
    //    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    //    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    //        CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

- (void)line2{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColorFromHEX(0xffee5a,1) CGColor]);
    
    float y=_currentLinePointY;
    
    CGPathMoveToPoint(path, NULL, -5, y);//-5 去掉上线波动小段
    
    
    for(float x=0;x<=SCREEN_WIDTH;x++){
        y= a * sin( (x+270 - 30)/180*M_PI + 4*b2/M_PI ) * 10 + _currentLinePointY ;
        CGPathAddLineToPoint(path, nil, x, y);//10 控制波动高度
    }
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

- (void)line3{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColorFromHEX(0x7cff92,1) CGColor]);
    
    float y=_currentLinePointY;
    
    CGPathMoveToPoint(path, NULL, -5, y);//-5 去掉上线波动小段
    
    
    for(float x=0;x<=SCREEN_WIDTH;x++){
        y= a * sin( (x+180 - 60 )/180*M_PI + 4*b3/M_PI ) * 10 + _currentLinePointY ;
        CGPathAddLineToPoint(path, nil, x, y);//10 控制波动高度
    }
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

@end
