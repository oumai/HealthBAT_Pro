//
//  BATWriteTextViewTableViewCell.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWriteTextViewTableViewCell.h"
#import "Masonry.h"

@implementation BATWriteTextViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textView = [[YYTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = UIColorFromHEX(0x333333, 1);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset =  UIEdgeInsetsMake(4,4,4,4);
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _textView.tag = 1;
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderTextColor = UIColorFromHEX(0X999999, 1);
        
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 20.f;
        _textView.linePositionModifier = mod;
        
        [self addSubview:_textView];
        
        _wordCountLabel = [[UILabel alloc] init];
        _wordCountLabel.font = [UIFont systemFontOfSize:12];
        _wordCountLabel.textAlignment = NSTextAlignmentRight;
        _wordCountLabel.textColor = UIColorFromHEX(0x999999, 1);
        [self.contentView addSubview:_wordCountLabel];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    [_wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(_textView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
