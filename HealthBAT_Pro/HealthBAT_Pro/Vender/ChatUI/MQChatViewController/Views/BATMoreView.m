//
//  BATMoreView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/10/14.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMoreView.h"

@implementation BATMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        _cameraBtn = [[BATMoreMenuButton alloc] init];
        _cameraBtn.imageView.image = [UIImage imageNamed:@"icon-ps"];
        _cameraBtn.titleLabel.text = @"拍摄";
        [_cameraBtn.button addTarget:self action:@selector(cameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn.button.tag = 0;
        [self addSubview:_cameraBtn];
        
        _albumBtn = [[BATMoreMenuButton alloc] init];
        _albumBtn.imageView.image = [UIImage imageNamed:@"icon-zp"];
        _albumBtn.titleLabel.text = @"照片";
        [_albumBtn.button addTarget:self action:@selector(albumBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _albumBtn.button.tag = 1;
        [self addSubview:_albumBtn];
        
        WEAK_SELF(self);
        
        [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(24);
            make.size.mas_equalTo(CGSizeMake(30, 80));
        }];
        
        [_albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(_cameraBtn.mas_right).offset(50);
            make.size.mas_equalTo(CGSizeMake(30, 80));
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Action
- (void)cameraBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreView:buttonClicked:)]) {
        [self.delegate moreView:self buttonClicked:_cameraBtn.button];
    }
}

- (void)albumBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreView:buttonClicked:)]) {
        [self.delegate moreView:self buttonClicked:_albumBtn.button];
    }
}

@end
