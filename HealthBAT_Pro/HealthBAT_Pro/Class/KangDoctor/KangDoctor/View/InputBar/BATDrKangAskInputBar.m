//
//  BATDrKangAskInputBar.m
//  HealthBAT_Pro
//
//  Created by mac on 2018/2/28.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangAskInputBar.h"

@implementation BATDrKangAskInputBar


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        
        [self addSubview:self.nextBtn];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.bottom.equalTo(@-10);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10-60-10));
            make.top.equalTo(@10);
            make.height.mas_equalTo(30);
        }];
        
     
    }
    return self;
}

#pragma mark - getter
- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];        
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:UIColorFromHEX(0xff9c00, 1)];
        _nextBtn.layer.cornerRadius = 5.0f;
    }
    return _nextBtn;
}

- (YYTextView *)textView {
    
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectZero];
        _textView.layer.cornerRadius = 5.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderText = @"输入名称";
        _textView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
