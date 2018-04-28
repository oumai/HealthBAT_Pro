//
//  BATHeaderView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHeaderView.h"

@interface BATHeaderView()
@property (nonatomic,strong) BATGraditorButton *lineView;

@end
@implementation BATHeaderView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.chatBtn];
        [self.chatBtn setTitle:@"图文咨询" forState:UIControlStateNormal];
        [self.chatBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
        self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.chatBtn.tag = 0;
        [self.chatBtn addTarget:self action:@selector(changeLineAction:) forControlEvents:UIControlEventTouchUpInside];
        
        WEAK_SELF(self)
        
        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.mas_left).offset(0);
            make.height.equalTo(@45);
            NSInteger width = SCREEN_WIDTH/2;
            make.width.mas_equalTo(width);
        }];
        
        [self addSubview:self.bookBtn];
        [self.bookBtn setTitle:@"预约问诊" forState:UIControlStateNormal];
        [self.bookBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        self.bookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.bookBtn addTarget:self action:@selector(changeLineAction:) forControlEvents:UIControlEventTouchUpInside];
        self.bookBtn.tag = 1;
        
        
        [self.bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.chatBtn.mas_right).offset(0);
            make.height.equalTo(@45);
            make.centerY.equalTo(self.chatBtn.mas_centerY);
            NSInteger width = SCREEN_WIDTH/2;
            make.width.mas_equalTo(width);
        }];
        
        [self addSubview:self.lineView];
        self.lineView.backgroundColor = UIColorFromHEX(0X45A0F0, 1);
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.chatBtn.mas_centerX);
            make.height.equalTo(@2);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
        }];
        
        UIView *verView = [UIView new];
        verView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
        [self addSubview:verView];
        [verView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.chatBtn.mas_right).offset(0);
            make.centerY.equalTo(self.chatBtn.mas_centerY);
            make.height.equalTo(@35);
            make.width.equalTo(@1);
        }];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withLineWidth:(NSInteger)width {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.chatBtn];
        [self.chatBtn setTitle:@"图文咨询" forState:UIControlStateNormal];
        [self.chatBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
        self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.chatBtn.tag = 0;
        [self.chatBtn addTarget:self action:@selector(changeLineAction:) forControlEvents:UIControlEventTouchUpInside];
        
        WEAK_SELF(self)
        
        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self)
            make.left.equalTo(self.mas_left).offset(0);
            make.height.equalTo(@45);
            NSInteger widths = SCREEN_WIDTH/2;
            make.width.mas_equalTo(widths);
        }];
        
        [self addSubview:self.bookBtn];
        [self.bookBtn setTitle:@"预约问诊" forState:UIControlStateNormal];
        [self.bookBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        self.bookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.bookBtn addTarget:self action:@selector(changeLineAction:) forControlEvents:UIControlEventTouchUpInside];
        self.bookBtn.tag = 1;
        
        
        [self.bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.chatBtn.mas_right).offset(0);
            make.height.equalTo(@45);
            make.centerY.equalTo(self.chatBtn.mas_centerY);
            NSInteger widtha = SCREEN_WIDTH/2;
            make.width.mas_equalTo(widtha);
        }];
        
        [self addSubview:self.lineView];
        self.lineView.backgroundColor = UIColorFromHEX(0X45A0F0, 1);
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.chatBtn.mas_centerX);
            make.height.equalTo(@2);
            make.width.equalTo(@(width));
            make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
        }];
        
        UIView *verView = [UIView new];
        verView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);
        [self addSubview:verView];
        [verView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.chatBtn.mas_right).offset(0);
            make.centerY.equalTo(self.chatBtn.mas_centerY);
            make.height.equalTo(@35);
            make.width.equalTo(@1);
        }];
    }
    return self;
}



-(void)changeLineAction:(UIButton *)btn {
    
    [self publicModthWithPages:btn.tag];
    
    if ([self.delegate respondsToSelector:@selector(BATHeaderViewSeleWithPage:)]) {
        [self.delegate BATHeaderViewSeleWithPage:btn.tag];
    }
}

-(void)setLineViewPostionWihPage:(NSInteger)pages {
    [self publicModthWithPages:pages];
}

-(void)publicModthWithPages:(NSInteger)pages {
    switch (pages) {
        case 0: {
          //  [self.chatBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
            [self.chatBtn setGradientColors:@[START_COLOR,END_COLOR]];
//            [self.bookBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
            [self.bookBtn setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.isHalf) {
                   
                    make.width.equalTo(@100);
                }else {
                   make.width.equalTo(@(SCREEN_WIDTH/2));
                }
                make.height.equalTo(@2);
          make.centerX.equalTo(self.chatBtn.mas_centerX);
                make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
            }];
            [self needsUpdateConstraints];
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
            break;
        }
        case 1: {
//            [self.chatBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
            [self.chatBtn setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
//            [self.bookBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
            [self.bookBtn setGradientColors:@[START_COLOR,END_COLOR]];
            
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.isHalf) {
                    
                    make.width.equalTo(@100);
                }else {
                    make.width.equalTo(@(SCREEN_WIDTH/2));
                }
                make.centerX.equalTo(self.bookBtn.mas_centerX);
                make.height.equalTo(@2);
                make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
            }];
            [self needsUpdateConstraints];
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
            break;
        }
    }
}

-(void)selectPages:(NSInteger)pages {
    switch (pages) {
        case 0: {
//            [self.chatBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
            [self.chatBtn setGradientColors:@[START_COLOR,END_COLOR]];
//            [self.bookBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
            [self.bookBtn setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
            
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.isHalf) {
                    
                    make.width.equalTo(@100);
                }else {
                    make.width.equalTo(@(SCREEN_WIDTH/2));
                }
                make.centerX.equalTo(self.chatBtn.mas_centerX);
                make.height.equalTo(@2);
                make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
            }];
            [self needsUpdateConstraints];
            [self layoutIfNeeded];

            break;
        }
        case 1: {
//            [self.chatBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
            [self.chatBtn setGradientColors:@[UIColorFromHEX(0X666666, 1)]];
//            [self.bookBtn setTitleColor:UIColorFromHEX(0X45A0F0, 1) forState:UIControlStateNormal];
            [self.bookBtn setGradientColors:@[START_COLOR,END_COLOR]];
            
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.isHalf) {
                   
                              make.width.equalTo(@100);
                }else {
                             make.width.equalTo(@(SCREEN_WIDTH/2));
                }
                make.height.equalTo(@2);
       make.centerX.equalTo(self.bookBtn.mas_centerX);
                make.bottom.equalTo(self.chatBtn.mas_bottom).offset(0);
            }];
            [self needsUpdateConstraints];
            [self layoutIfNeeded];

            break;
        }
    }
}

#pragma mark SETTER - GETTER
-(BATGraditorButton *)lineView {
    if (!_lineView) {
        _lineView = [BATGraditorButton new];
        _lineView.enablehollowOut = YES;
        [_lineView setGradientColors:@[START_COLOR,END_COLOR]];
        
    }
    return _lineView;
}

-(BATGraditorButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [BATGraditorButton new];
        _chatBtn.titleLabel.numberOfLines = 0;
        _chatBtn.enbleGraditor = YES;
        _chatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _chatBtn;
}

-(BATGraditorButton *)bookBtn {
    if (!_bookBtn) {
        _bookBtn = [BATGraditorButton new];
        _bookBtn.enbleGraditor = YES;
    }
    return _bookBtn;
}

@end
