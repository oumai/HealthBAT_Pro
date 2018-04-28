//
//  BATEditGroupAccouncementView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATEditGroupAccouncementView.h"

@implementation BATEditGroupAccouncementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[YYTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = UIColorFromHEX(0x333333, 1);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset =  UIEdgeInsetsMake(4,4,4,4);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _textView.placeholderText = @"发布群公告";
        [self addSubview:_textView];
        
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 20.f;
        _textView.linePositionModifier = mod;
        
        _wordCountLabel = [[UILabel alloc] init];
        _wordCountLabel.backgroundColor = [UIColor whiteColor];
        _wordCountLabel.textAlignment = NSTextAlignmentRight;
        _wordCountLabel.font = [UIFont systemFontOfSize:9];
        _wordCountLabel.textColor = UIColorFromRGB(103, 103, 103, 1);
        _wordCountLabel.text = @"0/200";
        [self addSubview:_wordCountLabel];
        
        [self setupConstraints];
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

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    [_wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(_textView.mas_bottom);
        make.height.mas_equalTo(21);
    }];
}

@end
