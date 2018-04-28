//
//  BATHealthCircleInputBar.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthCircleInputBar.h"

@implementation BATHealthCircleInputBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(238, 238, 238, 1.0f);
        
        _textView = [[YYTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = 6.0f;
        _textView.layer.masksToBounds = YES;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _textView.placeholderText = @"评论";
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.font = [UIFont systemFontOfSize:15];
        [self addSubview:_textView];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

@end
