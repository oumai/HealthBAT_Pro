//
//  BATHealthThreeSecondSlider.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSlider.h"
#import "BATHealthThreeSecondSlider+Draw.h"

@interface BATHealthThreeSecondSlider ()

@end

@implementation BATHealthThreeSecondSlider
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _diskFillColor = [UIColor clearColor];
    _diskColor = [UIColor grayColor];
    _trackColor = [UIColor whiteColor];
    
    _lineWidth = 5.0;
    _backtrackLineWidth = 5.0;
    _trackShadowOffset = CGPointZero;
    _trackShadowColor = [UIColor grayColor];
    _thumbLineWidth = 4.0;
    _thumbRadius = 13.0;
    _endThumbTintColor = [UIColor groupTableViewBackgroundColor];
    _endThumbStrokeHighlightedColor = [UIColor blueColor];
    _endThumbStrokeColor = [UIColor redColor];
    _trackFillColor = self.tintColor;
    
    _numberOfRounds = 1;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    _endPointValue = 0.5;
}

#pragma mark - Override
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircularSliderInContext:context];
    
    Interval valuesInterval = IntervalMake(self.minimumValue, self.maximumValue, self.numberOfRounds);
    CGFloat endAngle = [BATHealthThreeSecondSliderHelper scaleToAngle:self.endPointValue inInterval:valuesInterval];
    
    [self drawFilledArcFromStartAngle:[BATHealthThreeSecondSliderHelper circleInitialAngle] endAngle:endAngle inContext:context];
    
    [self.endThumbTintColor setFill];
    if (self.isHighlighted) {
        [self.endThumbStrokeHighlightedColor setStroke];
    } else {
        [self.endThumbStrokeColor setStroke];
    }
    UIImage *image = self.endThumbImage;
    if (image) {
        [self drawThumbWithAngle:endAngle inContext:context];
        return;
    }
    [self drawThumbWithImage:image angle:endAngle inContext:context];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPosition = [touch locationInView:self];
    CGPoint startPoint = CGPointMake(RectCenter(self.bounds).x, 0);
    CGFloat value = [self newValueFromOldValue:self.endPointValue touchPosition:touchPosition startPosition:startPoint];
    
    self.endPointValue = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Setter & Getter
- (void)setNumberOfRounds:(NSInteger)numberOfRounds {
    _numberOfRounds = numberOfRounds;
    if (numberOfRounds < 0) {
        NSLog(@"Number of rounds has to positive value!");
    }
    [self setNeedsDisplay];
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    if (_endPointValue < _minimumValue) {
        _endPointValue = _minimumValue;
    }
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    if (_endPointValue > maximumValue) {
        _endPointValue = _maximumValue;
    }
}

- (void)setEndPointValue:(CGFloat)endPointValue {
    if (_endPointValue == endPointValue) {
        return;
    }
    _endPointValue = endPointValue;
    if (_endPointValue > _maximumValue) {
        _endPointValue = _maximumValue;
    }
    [self setNeedsDisplay];
}

- (CGFloat)radius {
    CGFloat radius = MIN(RectCenter(self.bounds).x, RectCenter(self.bounds).y);
    radius -= MAX(self.lineWidth, (self.thumbRadius + self.thumbLineWidth));
    return radius;
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    [self setNeedsDisplay];
}

#pragma mark - Private
- (CGFloat)newValueFromOldValue:(CGFloat)oldValue touchPosition:(CGPoint)touchPosition startPosition:(CGPoint)startPosition {
    CGFloat angle = [BATHealthThreeSecondSliderHelper angleBetweenFirstPoint:startPosition secondPoint:touchPosition inCircleWithCenter:RectCenter(self.bounds)];
    Interval interval = IntervalMake(self.minimumValue, self.maximumValue, self.numberOfRounds);
    CGFloat deltaValue = [BATHealthThreeSecondSliderHelper deltaInInterval:interval angle:angle value:oldValue];
    
    CGFloat newValue = oldValue + deltaValue;
    CGFloat range = self.maximumValue - self.minimumValue;
    if (newValue > self.maximumValue) {
        newValue -= range;
    } else if (newValue < self.minimumValue) {
        newValue += range;
    }
    return newValue;
}

@end
