//
//  BATSearchDrugCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSearchDrugCell.h"

@implementation BATSearchDrugCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        WEAK_SELF(self);
        [self.contentView addSubview:self.treatmentImageView];
        [self.treatmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(75);
            make.width.mas_equalTo(100);
        }];
        
        
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.treatmentImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
            make.top.equalTo(self.treatmentImageView.mas_top).offset(10);
        }];
        
        [self.contentView addSubview:self.facturerLbel];
        [self.facturerLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.treatmentImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        
        //        [self.contentView addSubview:self.shopcarImageView];
        //        [self.shopcarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            STRONG_SELF(self);
        //            make.right.equalTo(self.mas_right).offset(-15);
        //            make.bottom.equalTo(self.mas_bottom).offset(-15);
        //        }];
        
        [self setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0.5];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _nameLabel;
}

- (UILabel *)facturerLbel {
    if (!_facturerLbel) {
        _facturerLbel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
        _facturerLbel.numberOfLines = 0;
        _facturerLbel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _facturerLbel;
}

- (UIImageView *)treatmentImageView {
    if (!_treatmentImageView) {
        _treatmentImageView = [UIImageView new];
        _treatmentImageView.clipsToBounds = YES;
        _treatmentImageView.layer.cornerRadius = 6;
        _treatmentImageView.layer.borderWidth = 1;
        _treatmentImageView.layer.borderColor = BASE_LINECOLOR.CGColor;
    }
    return _treatmentImageView;
}

- (UIImageView *)shopcarImageView {
    if (!_shopcarImageView) {
        _shopcarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-search-shoppingcart"]];
    }
    return _shopcarImageView;
}

@end
