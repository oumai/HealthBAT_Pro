//
//  DrugNameCollectionViewCell.m
//  HealthBAT
//
//  Created by four on 16/8/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "DrugNameCollectionViewCell.h"

@implementation DrugNameCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(39);
            make.top.equalTo(self.contentView.mas_top).offset(23.5);
            make.right.equalTo(self.contentView.mas_right).offset(39);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(160);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.top.equalTo(self.imageView.mas_bottom).offset(32);
        }];
        
        [self.contentView addSubview:self.subNameLabel];
        [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.top.equalTo(self.subNameLabel.mas_bottom).offset(27);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = UIColorFromHEX(0x333333,1);
    }
    return _nameLabel;
}

- (UILabel *)subNameLabel {
    if (!_subNameLabel) {
        _subNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _subNameLabel.numberOfLines = 0;
        _subNameLabel.textColor = UIColorFromHEX(0x333333,1);
    }
    return _subNameLabel;
}


- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _priceLabel.numberOfLines = 0;
        _priceLabel.textColor = UIColorFromHEX(0xfd0119,1);
    }
    return _priceLabel;
}



@end
