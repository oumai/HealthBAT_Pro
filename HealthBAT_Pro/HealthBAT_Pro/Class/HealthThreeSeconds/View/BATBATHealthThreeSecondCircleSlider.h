//
//  BATBATHealthThreeSecondCircleSlider.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondSlider.h"

typedef NS_ENUM(NSInteger, SelectedThumb) {
    SelectedThumbNone = -1,
    SelectedThumbStartThumb = 0,
    SelectedThumbEndThumb = 1
};

@interface BATBATHealthThreeSecondCircleSlider : BATHealthThreeSecondSlider
@property (nonatomic, assign) SelectedThumb         selectedThumb;
@property (nonatomic, strong) UIColor               *startThumbTintColor;
@property (nonatomic, strong) UIColor               *startThumbStrokeColor;
@property (nonatomic, strong) UIColor               *startThumbStrokeHighlightedColor;
@property (nonatomic, strong) UIImage               *startThumbImage;

@property (nonatomic, assign) CGFloat               minimumValue;
@property (nonatomic, assign) CGFloat               maximumValue;
@property (nonatomic, assign) CGFloat               distance;
@property (nonatomic, assign) CGFloat               startPointValue;
@property (nonatomic, assign) CGFloat               endPointValue;

@property (nonatomic, assign) CGPoint               startThumbCenter;
@property (nonatomic, assign) CGPoint               endThumbCenter;
@end



