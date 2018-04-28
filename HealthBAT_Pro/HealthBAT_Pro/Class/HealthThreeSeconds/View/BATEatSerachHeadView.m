//
//  BATEatSerachHeadView.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEatSerachHeadView.h"

@implementation BATEatSerachHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self layoutOurView];
    }
    return self;
    
}
- (void)layoutOurView {
    
    [self addSubview:self.imageV];
    
    [self addSubview:self.textF];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self).offset(5);
        make.height.mas_equalTo(self.imageV.mas_width).multipliedBy(1);
//        make.width.mas_equalTo(40);
    }];
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        
        make.left.mas_equalTo(self.imageV.mas_right).offset(5);
        
    }];
//
}
- (UITextField *)textF {
    
    if (!_textF) {
        _textF = [[UITextField alloc] init];
        
        _textF.backgroundColor = [UIColor greenColor];
        _textF.layer.cornerRadius = 5;
        _textF.layer.masksToBounds = YES;
    }
    return _textF;
    
}
- (UIImageView *)imageV {
    
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.backgroundColor = [UIColor cyanColor];
        
    }
    return _imageV;
    
}
@end
