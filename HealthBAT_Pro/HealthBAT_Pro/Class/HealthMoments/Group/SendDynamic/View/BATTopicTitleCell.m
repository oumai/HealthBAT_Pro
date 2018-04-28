//
//  BATTopicTitleCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTopicTitleCell.h"

@implementation BATTopicTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        WEAK_SELF(self);
        [self.contentView addSubview:self.yyTextView];
        [self.yyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.contentView).offset(10);
            make.top.bottom.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.bottom.right.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(1);
            
        }];
    }
    return self;
}

- (YYTextView *)yyTextView {

    if (!_yyTextView) {
        _yyTextView = [[YYTextView alloc]init];
        _yyTextView.placeholderText = @"标题,诱人的会有更多人看哦~";
        _yyTextView.placeholderFont = [UIFont systemFontOfSize:15];
        _yyTextView.font = [UIFont systemFontOfSize:15];
//        _yyTextView.textContainerInset =  UIEdgeInsetsMake(4,4,4,4);
        _yyTextView.placeholderTextColor = UIColorFromHEX(0X999999, 1);
        _yyTextView.textColor = UIColorFromHEX(0X333333, 1);
        _yyTextView.tag = 0;
        _yyTextView.returnKeyType = UIReturnKeyDone;
        _yyTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _yyTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _yyTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
    }
    return _yyTextView;
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end
