//
//  BATHealthThreeSecondSlider+Draw.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSlider+Draw.h"

@implementation BATHealthThreeSecondSlider (Draw)
- (void)drawArcWithArc:(Arc)arc lineWidth:(CGFloat)lineWidth mode:(CGPathDrawingMode)mode inContext:(CGContextRef)context {
    
    Circle circle = arc.circle;
    CGPoint origin = circle.origin;
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddArc(context, origin.x, origin.y, circle.radius, arc.startAngle, arc.endAngle, 0);
    CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextDrawPath(context, mode);
    
    UIGraphicsPopContext();
}

- (void)drawDiskWithArc:(Arc)arc inContext:(CGContextRef)context {
    Circle circle = arc.circle;
    CGPoint origin = circle.origin;
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 0);
    CGContextAddArc(context, origin.x, origin.y, circle.radius, arc.startAngle, arc.endAngle, false);
    CGContextAddLineToPoint(context, origin.x, origin.y);
    CGContextDrawPath(context, kCGPathFill);
    
    UIGraphicsPopContext();
}

- (void)drawCircularSliderInContext:(CGContextRef)context {
    [self.diskColor setFill];
    [self.trackColor setStroke];
    
    Circle circle = CircleMake(RectCenter(self.bounds), self.radius);
    Arc sliderArc = ArcMake(circle, [BATHealthThreeSecondSliderHelper circleMinValue], [BATHealthThreeSecondSliderHelper circleMaxValue]);
    [self drawArcWithArc:sliderArc lineWidth:self.backtrackLineWidth mode:kCGPathFillStroke inContext:context];
}

- (void)drawFilledArcFromStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle inContext:(CGContextRef)context {
    [self.diskFillColor setFill];
    [self.trackFillColor setStroke];
    
    Circle circle = CircleMake(RectCenter(self.bounds), self.radius);
    Arc arc = ArcMake(circle, startAngle, endAngle);
    
    // fill Arc
    [self drawDiskWithArc:arc inContext:context];
    // stroke Arc
    [self drawArcWithArc:arc lineWidth:self.lineWidth mode:kCGPathStroke inContext:context];
}

- (void)drawShadowArcFromStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle inContext:(CGContextRef)context {
    [self.trackShadowColor setStroke];
    
    CGPoint origin = CGPointMake(RectCenter(self.bounds).x + self.trackShadowOffset.x, RectCenter(self.bounds).y + self.trackShadowOffset.y);
    Circle circle = CircleMake(origin, self.radius);
    Arc arc = ArcMake(circle, startAngle, endAngle);
    
    // stroke Arc
    [self drawArcWithArc:arc lineWidth:self.lineWidth mode:kCGPathStroke inContext:context];
}

- (CGPoint)drawThumbWithAngle:(CGFloat)angle inContext:(CGContextRef)context {
    Circle circle = CircleMake(RectCenter(self.bounds), self.radius);
    CGPoint thumbOrigin = [BATHealthThreeSecondSliderHelper endPointFromCircle:circle angle:angle];
    Circle thumbCircle = CircleMake(thumbOrigin, self.thumbRadius);
    Arc thumbArc = ArcMake(thumbCircle, [BATHealthThreeSecondSliderHelper circleMinValue], [BATHealthThreeSecondSliderHelper circleMaxValue]);
    
    [self drawArcWithArc:thumbArc lineWidth:self.thumbLineWidth mode:kCGPathFillStroke inContext:context];
    return thumbOrigin;
}

- (CGPoint)drawThumbWithImage:(UIImage *)image angle:(CGFloat)angle inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    Circle circle = CircleMake(RectCenter(self.bounds), self.radius);
    CGPoint thumbOrigin = [BATHealthThreeSecondSliderHelper endPointFromCircle:circle angle:angle];
    CGSize imageSize = image.size;
    CGRect imageFrame = CGRectMake(thumbOrigin.x - (imageSize.width / 2), thumbOrigin.y - (imageSize.height / 2), imageSize.width, imageSize.height);
    [image drawInRect:imageFrame];
    
    UIGraphicsPopContext();
    
    return thumbOrigin;
}

- (void)drawArcColorWithArc:(Arc)arc lineWidth:(CGFloat)lineWidth mode:(CGPathDrawingMode)model context:(CGContextRef)context {
//    Circle circle = arc.circle;
//    CGPoint origin = circle.origin;//圆点
//    CGFloat deltaValue = arc.endAngle-arc.startAngle;
}



















@end
