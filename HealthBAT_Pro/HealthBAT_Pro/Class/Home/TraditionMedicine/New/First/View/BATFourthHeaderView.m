//
//  BATFourthHeaderView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFourthHeaderView.h"

@implementation BATFourthHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.questionLabel];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.edges.equalTo(@0);
        }];

        [self setBottomBorderWithColor:UIColorFromHEX(0xfefefe, 1) width:SCREEN_WIDTH height:1.f];
    }
    return self;
}

#pragma mark -
- (UILabel *)questionLabel {

    if (!_questionLabel) {
        _questionLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xfefefe, 1) textAlignment:NSTextAlignmentCenter];
        _questionLabel.numberOfLines = 2;
    }
    return _questionLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
