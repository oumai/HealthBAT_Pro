//
//  BATTrainStudioSearchView.m
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioSearchView.h"

@implementation BATTrainStudioSearchView

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
        make.height.mas_offset(30);
        make.right.equalTo(self.mas_right).offset(-96);
    }];
    
    [self addSubview:self.certificationBtn];
    [self.certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(80);
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


- (UIButton *)certificationBtn{
    if (!_certificationBtn) {
        _certificationBtn = [UIButton  buttonWithType:UIButtonTypeCustom Title:@"讲师认证" titleColor:UIColorFromHEX(0xff3934, 1) backgroundColor:nil backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        
        _certificationBtn.layer.cornerRadius = 2;
        _certificationBtn.layer.borderColor = UIColorFromHEX(0xff3934, 1).CGColor;
        _certificationBtn.layer.borderWidth = 1;
        
        [_certificationBtn bk_whenTapped:^{
            if (self.certificationBtnClickBlock) {
                self.certificationBtnClickBlock();
            }
        }];
    }
    return _certificationBtn;
}

@end
