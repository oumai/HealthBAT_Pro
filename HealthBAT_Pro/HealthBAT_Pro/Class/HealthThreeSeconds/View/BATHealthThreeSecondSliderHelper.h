//
//  BATHealthThreeSecondSliderHelper.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef struct {
    CGFloat min;
    CGFloat max;
    NSInteger rounds;
} Interval;
Interval IntervalMake(CGFloat min, CGFloat max, NSInteger rounds);

typedef struct {
    CGPoint origin;
    CGFloat radius;
} Circle;
Circle CircleMake(CGPoint origin, CGFloat radius);

typedef struct {
    Circle circle;
    CGFloat startAngle;
    CGFloat endAngle;
} Arc;
Arc ArcMake(Circle circle, CGFloat startAngle, CGFloat endAngle);

CGPoint RectCenter(CGRect rect);
CGVector CGVectorMakeWithSourcePointEndPoint(CGPoint source, CGPoint end);
CGFloat DotProduct(CGVector v1, CGVector v2);
CGFloat Determinant(CGVector v1, CGVector v2);
CGFloat DotProductPoint(CGPoint source, CGPoint first, CGPoint second);
CGFloat DeterminantPoint(CGPoint source, CGPoint first, CGPoint second);

@interface BATHealthThreeSecondSliderHelper : NSObject
+ (CGFloat)circleMinValue;
+ (CGFloat)circleMaxValue;
+ (CGFloat)circleInitialAngle;

+ (CGFloat)degressFromRadians:(CGFloat)radians;
+ (CGFloat)angleBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second inCircleWithCenter:(CGPoint)center;
+ (CGPoint)endPointFromCircle:(Circle)circle angle:(CGFloat)angle;
+ (CGFloat)scaleValueFrom:(CGFloat)value fromSourceInterval:(Interval)source toDestinationInterval:(Interval)destination;
+ (CGFloat)scaleToAngle:(CGFloat)value inInterval:(Interval)interval;
+ (CGFloat)valueInInterval:(Interval)interval fromAngle:(CGFloat)angle;
+ (CGFloat)deltaInInterval:(Interval)interval angle:(CGFloat)angle value:(CGFloat)value;
+ (CGFloat)angleFromAlpha:(CGFloat)alpha toBeta:(CGFloat)beta;
@end
