//
//  BATTrainerAuthenticateView.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainerAuthenticateView.h"

@implementation BATTrainerAuthenticateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self pageLayout];
    }
    return self;
}

#pragma mark - Action
- (void)startBtnAction:(UIButton *)button
{
    if (self.startBlock) {
        self.startBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.imageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.startBtn];
    
    WEAK_SELF(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(80);
        make.size.mas_equalTo(CGSizeMake(180.5, 167.5));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.top.equalTo(self.imageView.mas_bottom).offset(45);
    }];
    
    float startBtnOffset = 110;
    if (iPhone4) {
        startBtnOffset = 20;
    } else if (iPhone5) {
        startBtnOffset = 50;
    }
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(startBtnOffset);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(250, 45));
    }];
}

#pragma mark - get & set
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-pxgzs-b"]];
    }
    return _imageView;
}

- (YYLabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 28 * 2;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"注册护理讲师，我们将为您提供国内最专业的医护从业者在线学习平台，让知识更好的传播和分享。"];
        string.yy_font = [UIFont systemFontOfSize:15];
        string.yy_color = [UIColor blackColor];
        string.yy_lineSpacing = 15;
        
        _contentLabel.attributedText = string;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

- (UIButton *)startBtn
{
    if (_startBtn == nil) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:@"立即开通工作室" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _startBtn.layer.cornerRadius = 50 / 2;
        _startBtn.layer.masksToBounds = YES;
    }
    return _startBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
