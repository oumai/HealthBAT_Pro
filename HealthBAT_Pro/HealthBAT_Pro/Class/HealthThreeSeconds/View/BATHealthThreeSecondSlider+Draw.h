//
//  BATHealthThreeSecondSlider+Draw.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSlider.h"
#import "BATHealthThreeSecondSliderHelper.h"
@interface BATHealthThreeSecondSlider (Draw)
- (void)drawArcWithArc:(Arc)arc lineWidth:(CGFloat)lineWidth mode:(CGPathDrawingMode)mode inContext:(CGContextRef)context;
- (void)drawDiskWithArc:(Arc)arc inContext:(CGContextRef)context;
- (void)drawCircularSliderInContext:(CGContextRef)context;
- (void)drawFilledArcFromStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle inContext:(CGContextRef)context;
- (void)drawShadowArcFromStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle inContext:(CGContextRef)context;
- (CGPoint)drawThumbWithAngle:(CGFloat)angle inContext:(CGContextRef)context;
- (CGPoint)drawThumbWithImage:(UIImage *)image angle:(CGFloat)angle inContext:(CGContextRef)context;
@end
