//
//  WriteSingleDiseaseFooterView.m
//  HealthBAT
//
//  Created by cjl on 16/8/3.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWriteSingleDiseaseFooterView.h"

@implementation BATWriteSingleDiseaseFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_consultBtn setFrame:CGRectMake(10, 30.0f, SCREEN_WIDTH - 20.0f, 40)];
//        [_consultBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [_consultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _consultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_consultBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
//        [_consultBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0xcdcdcd, 1)] forState:UIControlStateDisabled];
//        _consultBtn.layer.cornerRadius = 6.0f;
//        _consultBtn.layer.masksToBounds = YES;
//        _consultBtn.enabled = NO;
//        [self addSubview:_consultBtn];
        
        _consultBtn = [[BATGraditorButton alloc] init];
        [_consultBtn setFrame:CGRectMake(10, 30.0f, SCREEN_WIDTH - 20.0f, 40)];
        [_consultBtn setTitle:@"提交" forState:UIControlStateNormal] ;
        _consultBtn.enablehollowOut = YES;
        _consultBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _consultBtn.titleColor = [UIColor whiteColor];
        [_consultBtn setGradientColors:@[START_COLOR,END_COLOR]];
        _consultBtn.layer.masksToBounds = YES;
        _consultBtn.layer.cornerRadius = 6.0f;
        
        [self addSubview:_consultBtn];
    }
    return self;
}

@end
