//
//  BATHealthThreeSecondSliderHelper.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSliderHelper.h"

Interval IntervalMake(CGFloat min, CGFloat max, NSInteger rounds) {
    Interval interval;
    interval.min = min;
    interval.max = max;
    interval.rounds = rounds;
    return interval;
}

Circle CircleMake(CGPoint origin, CGFloat radius) {
    Circle circle;
    circle.origin = origin;
    circle.radius = radius;
    return circle;
}

Arc ArcMake(Circle circle, CGFloat startAngle, CGFloat endAngle) {
    Arc arc;
    arc.circle = circle;
    arc.startAngle = startAngle;
    arc.endAngle = endAngle;
    return arc;
}

CGPoint RectCenter(CGRect rect) {
    CGPoint point;
    point.x = rect.size.width / 2;
    point.y = rect.size.height / 2;
    return point;
}

CGVector CGVectorMakeWithSourcePointEndPoint(CGPoint source, CGPoint end) {
    CGVector vector;
    vector.dx = end.x - source.x;
    vector.dy = end.y - source.y;
    return vector;
}

CGFloat DotProduct(CGVector v1, CGVector v2) {
    return v1.dx * v2.dx + v1.dy * v2.dy;
}

CGFloat Determinant(CGVector v1, CGVector v2) {
    return v2.dx * v1.dy - v1.dx * v2.dy;
}

CGFloat DotProductPoint(CGPoint source, CGPoint fisrt, CGPoint second) {
    CGVector u = CGVectorMakeWithSourcePointEndPoint(source, fisrt);
    CGVector v = CGVectorMakeWithSourcePointEndPoint(source, second);
    return DotProduct(u, v);
}

CGFloat DeterminantPoint(CGPoint source, CGPoint fisrt, CGPoint second) {
    CGVector u = CGVectorMakeWithSourcePointEndPoint(source, fisrt);
    CGVector v = CGVectorMakeWithSourcePointEndPoint(source, second);
    return Determinant(u, v);
}

@implementation BATHealthThreeSecondSliderHelper
+ (CGFloat)circleMinValue {
    return 0;
}

+ (CGFloat)circleMaxValue {
    return 2 * M_PI;
}

+ (CGFloat)circleInitialAngle {
    return -M_PI_2;
}

// 弧度转角度
+ (CGFloat)degressFromRadians:(CGFloat)radians {
    return radians * 180.0 / (M_PI);
}

//
+ (CGFloat)angleBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second inCircleWithCenter:(CGPoint)center {
    CGFloat dotProdect = DotProductPoint(center, first, second);
    CGFloat determinant = DeterminantPoint(center, first, second);
    CGFloat angle = atan2(determinant, dotProdect);
    // change the angle interval
    CGFloat newAngle = (angle < 0) ? -angle : (M_PI * 2) - angle;
    return newAngle;
}

+ (CGPoint)endPointFromCircle:(Circle)circle angle:(CGFloat)angle {
    CGFloat x = circle.radius * cos(angle) + circle.origin.x;
    CGFloat y = circle.radius * sin(angle) + circle.origin.y;
    CGPoint point = CGPointMake(x, y);
    return point;
}

+ (CGFloat)scaleValueFrom:(CGFloat)value fromSourceInterval:(Interval)source toDestinationInterval:(Interval)destination {
    CGFloat sourceRange = (source.max - source.min) / source.rounds;
    CGFloat destinationRange = (destination.max - destination.min) / destination.rounds;
    CGFloat scaledValue = source.min + fmod((value - source.min), sourceRange);
    CGFloat newValue = (((scaledValue - source.min) * destinationRange) / sourceRange) + destination.min;
    return newValue;
}

+ (CGFloat)scaleToAngle:(CGFloat)value inInterval:(Interval)interval {
    Interval angleInterval = IntervalMake([self circleMinValue], [self circleMaxValue], 1);
    CGFloat angle = [self scaleValueFrom:value fromSourceInterval:interval toDestinationInterval:angleInterval];
    return angle;
}

+ (CGFloat)valueInInterval:(Interval)interval fromAngle:(CGFloat)angle {
    Interval angleInterval = IntervalMake([self circleMinValue], [self circleMaxValue], 1);
    CGFloat value = [self scaleValueFrom:angle fromSourceInterval:angleInterval toDestinationInterval:interval];
    return value;
}

+ (CGFloat)deltaInInterval:(Interval)interval angle:(CGFloat)angle value:(CGFloat)value {
    Interval angleInterval = IntervalMake([self circleMinValue], [self circleMaxValue], 1);
    CGFloat oldAngle = [self scaleToAngle:value inInterval:interval];
    CGFloat deltaAngle = [self angleFromAlpha:oldAngle toBeta:angle];
    return [self scaleValueFrom:deltaAngle fromSourceInterval:angleInterval toDestinationInterval:interval];
}

+ (CGFloat)angleFromAlpha:(CGFloat)alpha toBeta:(CGFloat)beta {
    CGFloat halfValue = [self circleMaxValue] / 2;
    // Rotate right
    CGFloat offset = alpha >= halfValue ? [self circleMaxValue] - alpha : -alpha;
    CGFloat offsetBeta = beta + offset;
    if (offsetBeta > halfValue) {
        return offsetBeta - [self circleMaxValue];
    } else {
        return offsetBeta;
    }
}
@end
