//
//  BATHealthFollowSearchView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowSearchView.h"

@implementation BATHealthFollowSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self pagesLayout];
        
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
- (void)searchButtonAction
{
    if (self.healthFollowSearchClick) {
        self.healthFollowSearchClick();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (self.healthFollowSearchClick) {
        self.healthFollowSearchClick();
    }
    return NO;
}

#pragma mark - Layout
- (void)pagesLayout
{
//    WEAK_SELF(self);
//    [self addSubview:self.searchButton];
//    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.center.equalTo(self);
//        make.width.mas_offset(SCREEN_WIDTH - 45);
//        make.height.mas_offset(30);
//    }];
    
    [self addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 30));
    }];
}

#pragma mark - get&set
- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.text = @"搜索感兴趣的视频";
        _searchTF.textColor = STRING_LIGHT_COLOR;
        
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-search"]];
        [leftIcon addSubview:searchImageView];
        [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UIButton *)searchButton
{
    if (_searchButton == nil) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@" 搜索感兴趣的视频" forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"home-search"] forState:UIControlStateNormal];
        [_searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _searchButton.layer.borderWidth = (1.0f / [UIScreen mainScreen].scale);
        _searchButton.layer.borderColor = [UIColor grayColor].CGColor;
        _searchButton.layer.cornerRadius = 15;
        _searchButton.layer.masksToBounds = YES;
        [_searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

@end
