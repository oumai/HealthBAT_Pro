//
//  BATCategoryCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/6/7.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCategoryCell.h"

@interface BATCategoryCell ()
/** 背景UIImageView */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 名称 */
@property (nonatomic, strong) UIView *separatorView;

@end
@implementation BATCategoryCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.nameLabel];
//        [self.contentView addSubview:self.separatorView];
        
    }
    return self;
}

#pragma mark - setter
- (void)setItemDataSource:(NSDictionary *)itemDataSource{
    
    self.bgImageView.image = [UIImage imageNamed:[itemDataSource objectForKey:@"imageName"]];
    self.nameLabel.text = [itemDataSource objectForKey:@"title"];
}


#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
    }];
    
//    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(10);
//        
//    }];
}

#pragma mark - lazy load

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
//        _nameLabel.backgroundColor = [UIColor redColor];
        _nameLabel.textColor = UIColorFromHEX(0x666666, 1);
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.backgroundColor = [UIColor whiteColor];
        _bgImageView.layer.cornerRadius = 20;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.contentMode = UIViewContentModeCenter;
    }
    return _bgImageView;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = UIColorFromHEX(0xff5f5f5, 1);
    }
    return _separatorView;
}
@end
