//
//  BATBATHealthThreeSecondCircleSlider.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBATHealthThreeSecondCircleSlider.h"
#import "BATHealthThreeSecondSlider+Draw.h"

@implementation BATBATHealthThreeSecondCircleSlider
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize endPointValue = _endPointValue;

#pragma mark - Override
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircularSliderInContext:context];
    
    Interval interval = IntervalMake(self.minimumValue, self.maximumValue, self.numberOfRounds);
    // get start angle from start value
    CGFloat startAngle = [BATHealthThreeSecondSliderHelper scaleToAngle:self.startPointValue inInterval:interval] + [BATHealthThreeSecondSliderHelper circleInitialAngle];
    // get end angle from end value
    CGFloat endAngle = [BATHealthThreeSecondSliderHelper scaleToAngle:self.endPointValue inInterval:interval] + [BATHealthThreeSecondSliderHelper circleInitialAngle];
    
    [self drawShadowArcFromStartAngle:startAngle endAngle:endAngle inContext:context];
    [self drawFilledArcFromStartAngle:startAngle endAngle:endAngle inContext:context];
    
    // end Thumb
    [self.endThumbTintColor setFill];
    if (self.isHighlighted && self.selectedThumb == SelectedThumbEndThumb) {
        [self.endThumbStrokeHighlightedColor setStroke];
    } else {
        [self.endThumbStrokeColor setStroke];
    }
    self.endThumbCenter = [self drawThumbWithAngle:endAngle inContext:context];
    if (self.endThumbImage) {
        self.endThumbCenter = [self drawThumbWithImage:self.endThumbImage angle:endAngle inContext:context];
    }
    
    // start Thumb
    [self.startThumbTintColor setFill];
    if (self.isHighlighted && self.selectedThumb == SelectedThumbStartThumb) {
        [self.startThumbStrokeHighlightedColor setStroke];
    } else {
        [self.startThumbStrokeColor setStroke];
    }
    self.startThumbCenter = [self drawThumbWithAngle:startAngle inContext:context];
    if (self.startThumbImage) {
        self.startThumbCenter = [self drawThumbWithImage:self.startThumbImage angle:startAngle inContext:context];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    
    CGPoint touchPosition = [touch locationInView:self];
    self.selectedThumb = [self thumbForTouchPosition:touchPosition];
    return self.selectedThumb != SelectedThumbNone;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.selectedThumb == SelectedThumbNone) {
        return NO;
    }
    
    // the position of the pan gesture
    CGPoint touchPosition = [touch locationInView:self];
    CGPoint startPoint = CGPointMake(RectCenter(self.bounds).x, 0);
    
    CGFloat oldValue = 0.0;
    if (self.selectedThumb == SelectedThumbStartThumb) {
        oldValue = self.startPointValue;
    } else {
        oldValue = self.endPointValue;
    }
    CGFloat value = [self newValueFromOldValue:oldValue touchPosition:touchPosition startPosition:startPoint];
    
    if (self.selectedThumb == SelectedThumbStartThumb) {
        self.startPointValue = value;
    } else {
        self.endPointValue =value;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark - Setter & Getter

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    if (self.startPointValue < minimumValue) {
        self.startPointValue = minimumValue;
    }
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    if (self.endPointValue > maximumValue) {
        self.endPointValue = maximumValue;
    }
}

- (void)setDistance:(CGFloat)distance {
    _distance = distance;
    if (distance > self.maximumValue - self.minimumValue) {
        NSLog(@"The distance value is greater than distance between max and min value");
        return;
    }
    self.endPointValue = self.startPointValue + distance;
}

- (void)setStartPointValue:(CGFloat)startPointValue {
    if (_startPointValue != startPointValue) {
        _startPointValue = startPointValue;
    } else {
        return;
    }
    if (_startPointValue < self.minimumValue) {
        _startPointValue = self.minimumValue;
    }
    if (self.distance > 0) {
        self.endPointValue = _startPointValue + self.distance;
    }
    [self setNeedsDisplay];
}

- (void)setEndPointValue:(CGFloat)endPointValue {
    if (_endPointValue == endPointValue && self.distance <= 0) {
        return;
    } else {
        _endPointValue = endPointValue;
    }
    if (endPointValue > self.maximumValue) {
        _endPointValue = self.maximumValue;
    }
    if (self.distance > 0) {
        self.startPointValue = _endPointValue - self.distance;
    }
    [self setNeedsDisplay];
}
#pragma mark - Private

- (SelectedThumb)thumbForTouchPosition:(CGPoint)touchPosition {
    if ([self isThumbWithCenterThumbCenter:self.startThumbCenter containsPointTouchPoint:touchPosition]) {
        return SelectedThumbStartThumb;
    } else if ([self isThumbWithCenterThumbCenter:self.endThumbCenter containsPointTouchPoint:touchPosition]) {
        return SelectedThumbEndThumb;
    } else {
        return SelectedThumbNone;
    }
}

- (BOOL)isThumbWithCenterThumbCenter:(CGPoint)thumbCenter containsPointTouchPoint:(CGPoint)touchPoint {
    // the coordinates of thumb from its center
    CGRect rect = CGRectMake(thumbCenter.x - self.thumbRadius, thumbCenter.y - self.thumbRadius, self.thumbRadius * 2, self.thumbRadius * 2);
    if (CGRectContainsPoint(rect, touchPoint)) {
        return YES;
    }
    
    CGFloat angle = [BATHealthThreeSecondSliderHelper angleBetweenFirstPoint:thumbCenter secondPoint:touchPoint inCircleWithCenter:RectCenter(self.bounds)];
    CGFloat degree = [BATHealthThreeSecondSliderHelper degressFromRadians:angle];
    
    // tolerance 15
    BOOL isInside = degree < 15 || degree > 345;
    return isInside;
}
@end
