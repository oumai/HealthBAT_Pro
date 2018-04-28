//
//  BATDrKangInputBar.m
//  HealthBAT_Pro
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangInputBar.h"

@implementation BATDrKangInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASE_BACKGROUND_COLOR;
        [self setTopBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
        
        WEAK_SELF(self);
        
        [self addSubview:self.changeButton];
        [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.bottom.equalTo(@-7.5);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
        
        [self addSubview:self.notiBtn];
        [self.notiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);

            make.left.equalTo(self.changeButton.mas_right).offset(2);
            make.centerY.equalTo(self.changeButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 24));
        }];
        
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            make.left.equalTo(self.notiBtn.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(@-9.5);
            make.top.equalTo(@9.5);
        }];
        
        [self addSubview:self.soundInputButton];
        [self.soundInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            make.left.equalTo(self.notiBtn.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(@-9.5);
            make.top.equalTo(@9.5);
        }];
    }
    return self;
}

#pragma mark - action
- (void)changeInputMode:(UIButton *)changeBtn {
    
    if (self.changeInputModeBlock) {
        self.changeInputModeBlock();
    }
}

- (void)sendTextMessage {
    
    if (self.sendTextMessageBlock) {
        self.sendTextMessageBlock();
    }
}

- (void)recognizerBegin {
    
    if (self.recognizerBeginBlock) {
        self.recognizerBeginBlock();
    }
}

- (void)recognizerStop {
    
    if (self.recognizerStopBlock) {
        self.recognizerStopBlock();
    }
}

- (void)recognizerAlert {
    
    if (self.recognizerAlertBlock) {
        self.recognizerAlertBlock();
    }
}
- (void)recognizerCancel {
    
    if (self.recognizerCancelBlock) {
        self.recognizerCancelBlock();
    }
}
- (void)recognizerContinue {
    
    if (self.recognizerContinueBlock) {
        self.recognizerContinueBlock();
    }
}


#pragma mark - getter
- (UIButton *)changeButton {
    
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton addTarget:self action:@selector(changeInputMode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_changeButton setImage:[UIImage imageNamed:@"icon-jp"] forState:UIControlStateNormal];

    }
    return _changeButton;
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
        _textView.placeholderText = @"";
        _textView.layer.borderColor = BASE_LINECOLOR.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.returnKeyType = UIReturnKeySend;
        
        _textView.hidden = YES;
    }
    return _textView;
}

- (UIButton *)soundInputButton {
    
    if (!_soundInputButton) {
        _soundInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _soundInputButton.layer.borderColor = STRING_MID_COLOR.CGColor;
        _soundInputButton.layer.borderWidth = 0.5;
        _soundInputButton.layer.cornerRadius = 5.0f;
        
        [_soundInputButton setTitleColor:STRING_MID_COLOR forState:UIControlStateNormal];
        _soundInputButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_soundInputButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_soundInputButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];

        [_soundInputButton setBackgroundImage:[Tools imageFromColor:BASE_BACKGROUND_COLOR] forState:UIControlStateNormal];
        [_soundInputButton setBackgroundImage:[Tools imageFromColor:BASE_LINECOLOR] forState:UIControlStateHighlighted];
        
        [_soundInputButton addTarget:self action:@selector(recognizerBegin) forControlEvents:UIControlEventTouchDown];
        [_soundInputButton addTarget:self action:@selector(recognizerStop) forControlEvents:UIControlEventTouchUpInside];
        [_soundInputButton addTarget:self action:@selector(recognizerAlert) forControlEvents:UIControlEventTouchDragExit];
        [_soundInputButton addTarget:self action:@selector(recognizerCancel) forControlEvents:UIControlEventTouchUpOutside];
        [_soundInputButton addTarget:self action:@selector(recognizerContinue) forControlEvents:UIControlEventTouchDragEnter];

    }
    return _soundInputButton;
}

- (UIButton *)notiBtn {
    
    if (!_notiBtn) {
        _notiBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_notiBtn setBackgroundImage:[UIImage imageNamed:@"dzbg"] forState:UIControlStateNormal];

        [_notiBtn setTitle:@" 打字" forState:UIControlStateNormal];
        _notiBtn.titleLabel.font = [UIFont systemFontOfSize:11];

        [_notiBtn sizeToFit];
    }
    return _notiBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
