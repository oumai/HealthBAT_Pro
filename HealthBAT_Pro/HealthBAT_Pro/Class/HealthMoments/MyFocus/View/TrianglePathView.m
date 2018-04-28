//
//  TrianglePathView.m
//  HealthBAT
//
//  Created by Wilson on 16/3/10.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "TrianglePathView.h"

@implementation TrianglePathView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawTriangle];
}

- (void) drawTriangle {
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    [bPath moveToPoint:CGPointMake(10, 0)];
    [bPath addLineToPoint:CGPointMake(0, 10)];
    [bPath addLineToPoint:CGPointMake(20, 10)];
    
    // 通过closePath结束画线
    [bPath closePath];
    
    // 通过添加最后一个点来结束画线
    //[bPath addLineToPoint:CGPointMake(20, 20)];
    
    // 设置线宽
    bPath.lineWidth = 0.5;
    
    // 设置线的颜色
    UIColor *lineColor = UIColorFromHEX(0xffffff, 1);
    [lineColor set];
    [bPath stroke];
    
    // 设置填充色
    UIColor *fillColor = UIColorFromHEX(0xffffff, 1);
    [fillColor set];
    [bPath fill];
}


@end
