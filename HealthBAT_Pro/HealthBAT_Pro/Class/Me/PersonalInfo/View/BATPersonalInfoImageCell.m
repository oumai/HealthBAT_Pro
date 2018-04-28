//
//  BATPersonalInfoImageCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonalInfoImageCell.h"

@interface BATPersonalInfoImageCell ()



@end


@implementation BATPersonalInfoImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.titleLabel.text = [dataDict objectForKey:@"title"];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(120);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.equalTo(weakSelf.mas_right).offset(-35);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment =NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}
@end
