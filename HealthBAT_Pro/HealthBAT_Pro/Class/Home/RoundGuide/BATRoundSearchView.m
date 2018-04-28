//
//  BATRoundSearchView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/6.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRoundSearchView.h"

@interface BATRoundSearchView () <UITextFieldDelegate>

@end

@implementation BATRoundSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self pageLayout];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.roundSearchBlock) {
        self.roundSearchBlock(textField.text);
    }
    return YES;
}

#pragma mark - pageLayout
- (void)pageLayout {
    [self addSubview:self.bgView];
    [self addSubview:self.searchTextField];
    [self addSubview:self.iconImageView];
    
    WEAK_SELF(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.iconImageView.mas_left).offset(-10);
        make.top.bottom.equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - get & set
- (UIImageView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        _bgView.lee_theme.LeeConfigImage(RoundGuide_icon_searchBG);
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UITextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        
        NSString *text = @"搜索病症、药品、医院、医生、资讯";
        
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:text];
        [placeHolder addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromHEX(0xffffff, 1)} range:NSMakeRange(0, text.length)];
        
        _searchTextField.attributedPlaceholder = placeHolder;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.textColor = UIColorFromHEX(0xffffff, 1);
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextField;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        NSString *imgStr = @"home_search_q";
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}
@end
