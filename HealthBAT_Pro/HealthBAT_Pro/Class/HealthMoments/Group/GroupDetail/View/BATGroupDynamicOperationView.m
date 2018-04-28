//
//  BATGroupDynamicOperationView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupDynamicOperationView.h"

@interface BATGroupDynamicOperationView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLineLeading;


@end

@implementation BATGroupDynamicOperationView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

#pragma mark - Private

#pragma mark - 滑块滑动
- (void)sliderAction:(UIButton *)button
{
    _sliderLineLeading.constant = button.frame.origin.x;
        
    [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Action

#pragma mark - 全部
- (IBAction)allButtonAction:(id)sender {
   
    if (_delegate && [_delegate respondsToSelector:@selector(groupDynamicOperationView:dynamicOprationClicked:)]) {
        [_delegate groupDynamicOperationView:self dynamicOprationClicked:BATGroupDetailDynamicOprationAll];
    }
    
    [self sliderAction:_allButton];
}

#pragma mark - 问题
- (IBAction)questionButton:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(groupDynamicOperationView:dynamicOprationClicked:)]) {
        [_delegate groupDynamicOperationView:self dynamicOprationClicked:BATGroupDetailDynamicOprationQuestion];
    }
    
    [self sliderAction:_questionButton];
}

#pragma mark - 动态
- (IBAction)dynamicButton:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(groupDynamicOperationView:dynamicOprationClicked:)]) {
        [_delegate groupDynamicOperationView:self dynamicOprationClicked:BATGroupDetailDynamicOprationDynamic];
    }
    
    [self sliderAction:_dynamicButton];
}

@end
