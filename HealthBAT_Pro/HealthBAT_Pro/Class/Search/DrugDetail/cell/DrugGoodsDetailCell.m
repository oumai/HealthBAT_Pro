//
//  DrugGoodsDetailCell.m
//  HealthBAT
//
//  Created by four on 16/8/25.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "DrugGoodsDetailCell.h"

@implementation DrugGoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        SelfWeak(self);
//        [self.contentView addSubview:self.imageV];
//        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            SelfStrong(self);
//            make.left.equalTo(self.contentView.mas_left).offset(39);
//            make.top.equalTo(self.contentView.mas_top).offset(23.5);
//            make.right.equalTo(self.contentView.mas_right).offset(-39);
//            make.height.mas_equalTo(432/590.0*(MainScreenWidth - 78));
//        }];
//        
//        [self.contentView addSubview:self.nameLabel];
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.top.equalTo(self.imageV.mas_bottom).offset(32);
//        }];
//        
//        [self.contentView addSubview:self.subNameLabel];
//        [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            SelfStrong(self);
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
//        }];
//        
//        [self.contentView addSubview:self.priceLabel];
//        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            SelfStrong(self);
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.top.equalTo(self.subNameLabel.mas_bottom).offset(27);
//        }];
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(39, 23, SCREEN_WIDTH - 78, 432/590.0*(SCREEN_WIDTH - 78))];
        
        _imageV.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_imageV];
//        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageV.frame) + 32,SCREEN_WIDTH,30)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(_imageV.frame) + 32, MainScreenWidth, 30);
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = UIColorFromHEX(0X333333,1);
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
//        _subNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(_subNameLabel.frame) + 10, MainScreenWidth, 30);
        _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLabel.frame) + 10,SCREEN_WIDTH,30)];
        _subNameLabel.font = [UIFont systemFontOfSize:16];
        _subNameLabel.textAlignment = NSTextAlignmentLeft;
        _subNameLabel.numberOfLines = 0;
        _subNameLabel.textColor = UIColorFromHEX(0X333333,1);
        _subNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_subNameLabel];
        
//        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(_subNameLabel.frame) + 27, MainScreenWidth, 30);
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_subNameLabel.frame) + 27,SCREEN_WIDTH,30)];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.numberOfLines = 0;
        _priceLabel.textColor = UIColorFromHEX(0Xfd0119,1);
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

//- (UIImageView *)imageV {
//    if (!_imageV) {
////        _imageV = [[UIImageView alloc] init];
//        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(39, 23, MainScreenWidth - 78, 432/590.0*(MainScreenWidth - 78))];
//        
//        _imageV.backgroundColor = [UIColor clearColor];
//    }
//    return _imageV;
//}
//
//- (UILabel *)nameLabel {
//    if (!_nameLabel) {
//        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.imageV.frame) + 32, MainScreenWidth, 30);
//        _nameLabel.numberOfLines = 0;
//        _nameLabel.textColor = [KMTools colorWithHexString:@"#333333"];
//        _nameLabel.backgroundColor = [UIColor clearColor];
//    }
//    return _nameLabel;
//}
//
//- (UILabel *)subNameLabel {
//    if (!_subNameLabel) {
//        _subNameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.subNameLabel.frame) + 10, MainScreenWidth, 30);
//        _subNameLabel.numberOfLines = 0;
//        _subNameLabel.textColor = [KMTools colorWithHexString:@"#333333"];
//        _subNameLabel.backgroundColor = [UIColor clearColor];
//    }
//    return _subNameLabel;
//}
//
//
//- (UILabel *)priceLabel {
//    if (!_priceLabel) {
//        _priceLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _nameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.subNameLabel.frame) + 27, MainScreenWidth, 30);
//        _priceLabel.numberOfLines = 0;
//        _priceLabel.textColor = [KMTools colorWithHexString:@"#fd0119"];
//    }
//    return _priceLabel;
//}
//

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
