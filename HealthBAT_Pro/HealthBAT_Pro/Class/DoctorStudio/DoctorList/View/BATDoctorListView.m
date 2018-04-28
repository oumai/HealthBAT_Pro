//
//  BATDoctorListView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorListView.h"

@interface BATDoctorListView () <UITextFieldDelegate>

@end

@implementation BATDoctorListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self pageLayout];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (self.searchBlock) {
        self.searchBlock();
    }
    
    return NO;
}

#pragma mark - Action
- (void)sortButtonAction
{
    if (self.sortBlock) {
        self.sortBlock();
    }
}

- (void)filterButtonAction
{
    if (self.filterBlock) {
        self.filterBlock();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.topView];
    [self.topView addSubview:self.searchTF];
    [self addSubview:self.categoryTableView];
    [self addSubview:self.menuView];
    [self.menuView addSubview:self.sortButton];
    [self.menuView addSubview:self.filterButton];
    [self addSubview:self.doctorTableView];
    
    WEAK_SELF(self);
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.bottom.equalTo(self.topView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.topView.mas_bottom);
        make.width.mas_offset(120);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.categoryTableView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(50);
    }];
    
    
    CGFloat offsetLeft = (SCREEN_WIDTH - 120 - 75 * 2 - 40) / 2;
    
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(75, 30));
        make.left.equalTo(self.menuView.mas_left).offset(offsetLeft);
        make.centerY.equalTo(self.menuView.mas_centerY);
    }];
    
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_offset(CGSizeMake(75, 30));
        make.left.equalTo(self.sortButton.mas_right).offset(40);
        make.centerY.equalTo(self.menuView.mas_centerY);
    }];
    
    [self.doctorTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.equalTo(self.categoryTableView.mas_right);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.topView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    [self.menuView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH - 120 height:0];
    [self.categoryTableView setRightBorderWithColor:BASE_LINECOLOR width:0 height:0];
}

#pragma mark - get & set

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:@"搜医生名、科室、疾病" BorderStyle:UITextBorderStyleNone];
        _searchTF.backgroundColor = UIColorFromHEX(0xf8f8f8, 1);
        [_searchTF setTintColor:UIColorFromRGB(59, 145, 248, 1)];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索图标"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        _searchTF.layer.cornerRadius = 2.f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UIView *)menuView
{
    if (_menuView == nil) {
        _menuView = [[UIView alloc] init];
        _menuView.backgroundColor = [UIColor whiteColor];
    }
    return _menuView;
}

- (UIButton *)sortButton
{
    if (_sortButton == nil) {
        _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortButton setTitle:@"排序" forState:UIControlStateNormal];
        [_sortButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"ic-px"] forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(sortButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sortButton.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
        _sortButton.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
        _sortButton.layer.cornerRadius = 6.0f;
        _sortButton.layer.masksToBounds = YES;
    }
    return _sortButton;
}

- (UIButton *)filterButton
{
    if (_filterButton == nil) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"ic-sx"] forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(filterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _filterButton.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
        _filterButton.layer.borderWidth = (1.0 / [UIScreen mainScreen].scale);
        _filterButton.layer.cornerRadius = 6.0f;
        _filterButton.layer.masksToBounds = YES;
    }
    return _filterButton;
}

- (UITableView *)categoryTableView
{
    if (_categoryTableView == nil) {
        _categoryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryTableView.backgroundColor = UIColorFromHEX(0xf0f0f0, 1);
    }
    return _categoryTableView;
}

- (UITableView *)doctorTableView
{
    if (_doctorTableView == nil) {
        _doctorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _doctorTableView.estimatedRowHeight = 100;
        _doctorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _doctorTableView;
}


@end
