//
//  BATTrainStudioSearchDoctorView.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioSearchDoctorView.h"

@implementation BATTrainStudioSearchDoctorView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self pagesLayout];
    }
    
    return self;
}

- (void)pagesLayout{
    
    WEAK_SELF(self);
    [self addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-60);
        make.height.mas_offset(30);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入要搜索的讲师姓名";
        _searchTF.textColor = UIColorFromHEX(0x666666, 1);
        _searchTF.backgroundColor = BASE_BACKGROUND_COLOR;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        
        _searchTF.layer.cornerRadius = 2.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton  buttonWithType:UIButtonTypeCustom Title:@"取消" titleColor:[UIColor redColor] backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:18]];
        
        [_cancelBtn bk_whenTapped:^{
            if (self.cancelBtnClickBlock) {
                self.cancelBtnClickBlock();
            }
        }];
    }
    return _cancelBtn;
}

@end
