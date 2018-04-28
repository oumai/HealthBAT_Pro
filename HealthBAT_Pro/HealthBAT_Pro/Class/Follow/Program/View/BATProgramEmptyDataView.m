//
//  BATProgramEmptyDataView.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramEmptyDataView.h"
@interface BATProgramEmptyDataView ()
/** <#属性描述#> */
@property (nonatomic, strong) UIImageView *bgImageView;
/** <#属性描述#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#属性描述#> */
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation BATProgramEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.addButton];
    }
    return self;
}
- (void)addButtonClick{
    
    if (self.addButtonBlock) {
        self.addButtonBlock();
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(75/2);
        make.centerX.equalTo(self.mas_centerX);

    }];
    

}
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"Follow_tjfa_Sel"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:24];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"蜕变  一切才开始";
    }
    return _titleLabel;
    
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image= [UIImage imageNamed:@"Follow_No_Program_Bg"];
    }
    return _bgImageView;
}
@end
