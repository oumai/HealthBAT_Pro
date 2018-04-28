//
//  BATHealthThreeSecondSlider.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATHealthThreeSecondSlider : UIControl
@property (nonatomic, strong) UIColor           *diskFillColor;
@property (nonatomic, strong) UIColor           *diskColor;
@property (nonatomic, strong) UIColor           *trackFillColor;
@property (nonatomic, strong) UIColor           *trackColor;

@property (nonatomic, assign) CGFloat           lineWidth;
@property (nonatomic, assign) CGFloat           backtrackLineWidth;
@property (nonatomic, assign) CGPoint           trackShadowOffset;

@property (nonatomic, strong) UIColor           *trackShadowColor;
@property (nonatomic, assign) CGFloat           thumbLineWidth;
@property (nonatomic, assign) CGFloat           thumbRadius;
@property (nonatomic, strong) UIColor           *endThumbTintColor;
@property (nonatomic, strong) UIColor           *endThumbStrokeHighlightedColor;
@property (nonatomic, strong) UIColor           *endThumbStrokeColor;

@property (nonatomic, strong) UIImage           *endThumbImage;
@property (nonatomic, assign) NSInteger         numberOfRounds;
@property (nonatomic, assign) CGFloat           minimumValue;
@property (nonatomic, assign) CGFloat           maximumValue;
@property (nonatomic, assign) CGFloat           endPointValue;
@property (nonatomic, assign) CGFloat           radius;
@property (nonatomic, assign) BOOL              isHighlighted;

- (CGFloat)newValueFromOldValue:(CGFloat)oldValue touchPosition:(CGPoint)touchPosition startPosition:(CGPoint)startPosition;

@end
