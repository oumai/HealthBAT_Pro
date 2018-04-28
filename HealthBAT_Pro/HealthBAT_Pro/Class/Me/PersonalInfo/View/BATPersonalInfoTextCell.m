//
//  BATPersonalInfoTextCell.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPersonalInfoTextCell.h"
@interface BATPersonalInfoTextCell ()


@end

@implementation BATPersonalInfoTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textSubLabel];
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    
    self.titleLabel.text = [dataDict objectForKey:@"title"];
    self.textSubLabel.text = [dataDict objectForKey:@"subTitle"];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
//        make.width.mas_equalTo(@80);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.textSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-35);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(10);
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)textSubLabel{
    if (!_textSubLabel) {
        _textSubLabel = [[UILabel alloc]init];
        _textSubLabel.textAlignment = NSTextAlignmentRight;
    }
    return _textSubLabel;
}
@end
