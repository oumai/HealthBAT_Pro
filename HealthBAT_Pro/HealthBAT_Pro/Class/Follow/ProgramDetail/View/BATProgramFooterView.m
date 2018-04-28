//
//  BATProgramFooterView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramFooterView.h"

@implementation BATProgramFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self pageLayout];
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
- (void)testButtonAction:(UIButton *)button
{
    DDLogDebug(@"Test");
    if (self.testAction) {
        self.testAction();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
//    [self addSubview:self.titleLabel];
//    [self addSubview:self.contentLabel];
    [self addSubview:self.testButton];
    
//    WEAK_SELF(self);
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.top.equalTo(self.mas_top).offset(17);
//        make.width.mas_equalTo(SCREEN_WIDTH - 30);
//        make.height.mas_offset(14);
//        make.centerX.equalTo(self.mas_centerX);
//    }];
//    
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.width.mas_equalTo(SCREEN_WIDTH - 60);
//        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
//    }];
    WEAK_SELF(self);
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(175, 45));
        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(self.mas_bottom).offset(30);
    }];
    
}

#pragma mark - get & set
//- (UILabel *)titleLabel
//{
//    if (_titleLabel == nil) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _titleLabel.text = @"执行要点（*温馨提示）";
//    }
//    return _titleLabel;
//}

//- (UILabel *)contentLabel
//{
//    if (_contentLabel == nil) {
//        _contentLabel = [[UILabel alloc] init];
////        _contentLabel.font = [UIFont systemFontOfSize:14];
////        _contentLabel.textColor = UIColorFromHEX(0x333333, 1);
//        _contentLabel.numberOfLines = 0;
////        _contentLabel.backgroundColor = [UIColor yellowColor];
//    }
//    return _contentLabel;
//}

- (BATGraditorButton *)testButton
{
    if (_testButton == nil) {
        _testButton = [[BATGraditorButton alloc]init];
        [_testButton setTitle:@"再测一次" forState:UIControlStateNormal];
//        [_testButton setBackgroundImage:[Tools imageFromColor:UIColorFromHEX(0x45a0f0, 1)] forState:UIControlStateNormal];
        _testButton.titleColor = [UIColor whiteColor];
        _testButton.enablehollowOut = YES;
        [_testButton setGradientColors:@[START_COLOR,END_COLOR]];
     //   [_testButton setTitleColor:UIColorFromHEX(0xffffff, 1) forState:UIControlStateNormal];
        [_testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _testButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _testButton.layer.cornerRadius = 5.0f;
        _testButton.layer.masksToBounds = YES;
    }
    return _testButton;
}

@end
