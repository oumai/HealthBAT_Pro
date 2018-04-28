//
//  BATFindSearchBarView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindSearchBarView.h"

@implementation BATFindSearchBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入关键字查找";
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.barTintColor = [UIColor blackColor];
        _searchBar.tintColor = [UIColor whiteColor];
        [self addSubview:_searchBar];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"取消" titleColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:16]];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        [self setupConstraints];

    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self).offset(10);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(_searchBar.mas_right);
        make.width.mas_equalTo(60);
    }];
}

#pragma mark - Action

#pragma mark - 取消
- (void)cancelButtonTapped
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
