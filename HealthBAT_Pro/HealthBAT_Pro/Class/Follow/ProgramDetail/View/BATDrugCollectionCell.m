//
//  BATDrugCollectionCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugCollectionCell.h"

@interface BATDrugCollectionCell()


@end

@implementation BATDrugCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(80, 60));
            
        }];
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.iconImageView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
            
        }];
        
        [self.contentView addSubview:self.salesLb];
        [self.salesLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.titleLb.mas_left).offset(0);
            make.top.equalTo(self.titleLb.mas_bottom).offset(10);

        }];
        
        [self.contentView addSubview:self.produtLb];
        [self.produtLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.equalTo(self.salesLb.mas_right).offset(20);
            make.bottom.equalTo(self.salesLb.mas_bottom).offset(0);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromHEX(0X666666, 1);
        
        [self.produtLb addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.produtLb.mas_centerY);
            make.left.right.equalTo(self.produtLb).offset(0);
            make.height.mas_equalTo(1);
        }];
        
    }
    
    return self;
}


- (void)setModel:(ProductList *)model {

    _model = model;
    
    self.titleLb.text = model.PRODUCT_NAME;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.km1818.com/product%@",model.SKU_IMG_PATH]] placeholderImage:[UIImage imageNamed:@"默认图"]];
    self.salesLb.text = [NSString stringWithFormat:@"¥%@",model.SALE_UNIT_PRICE];
    self.produtLb.text = [NSString stringWithFormat:@"¥%@",model.MARKET_PRICE];
}

#pragma mark - Lazy Load
- (UILabel *)titleLb {

    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:12];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _titleLb;
}

- (UILabel *)salesLb {

    if (!_salesLb) {
        _salesLb = [[UILabel alloc]init];
        _salesLb.textColor = UIColorFromHEX(0Xff0707, 1);
        _salesLb.font = [UIFont systemFontOfSize:13];
//        _salesLb.text =  @"¥ 98.00";
    }
    return _salesLb;
}

- (UILabel *)produtLb {

    if (!_produtLb) {
        _produtLb = [[UILabel alloc]init];
        _produtLb.textColor = UIColorFromHEX(0X666666, 1);
        _produtLb.font = [UIFont systemFontOfSize:11];
//        _produtLb.text = @"¥ 998.00";
    }
    return _produtLb;
}

- (UIImageView *)iconImageView {

    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

@end
